# == Class role::eventlogging::processor
# Reads raw events, parses and validates them, and then sends
# them along for further consumption.
#
# filtertags: labs-project-deployment-prep
class role::eventlogging::analytics::processor{
    include role::eventlogging::analytics::server

    $kafka_brokers_string      = $role::eventlogging::analytics::server::kafka_config['brokers']['string']

    $kafka_consumer_group = hiera(
        'eventlogging_processor_kafka_consumer_group',
        'eventlogging_processor_client_side_00'
    )

    # Run N parallel client side processors.
    # These will auto balance amongst themselves.
    $client_side_processors = hiera(
        'eventlogging_client_side_processors',
        ['client-side-00', 'client-side-01']
    )

    # client-side-raw URI is defined for DRY purposes in role::eventlogging::analytics::server.
    $kafka_client_side_raw_uri = $role::eventlogging::analytics::server::kafka_client_side_raw_uri

    # Choose the eventlogging URI scheme to use for consumers and producer (inputs vs outputs).
    # This allows us to try out different Kafka handlers and different kafka clients
    # that eventlogging supports.  The default is kafka://.  Also available is kafka-confluent://
    # eventlogging::processor is the only configured analytics eventlogging kafka producer, so we
    # only need to define this here.
    $kafka_producer_scheme = hiera('eventlogging_kafka_producer_scheme', 'kafka://')

    # Read in raw events from Kafka, process them, and send them to
    # the schema corresponding to their topic in Kafka.
    $kafka_schema_output_uri  = "${kafka_producer_scheme}/${kafka_brokers_string}?topic=eventlogging_{schema}"
    $kafka_mixed_output_uri = "${kafka_producer_scheme}/${kafka_brokers_string}?topic=eventlogging-valid-mixed"

    # Increase number and backoff time of retries for async
    # analytics uses.  If metadata changes, we should give
    # more time to retry.
    $kafka_producer_args = $kafka_producer_scheme ? {
        # args for kafka-confluent handler writer
        'kafka-confluent://' => 'message.send.max.retries=6,retry.backoff.ms=200',
        # args for kafka-python handler writer
        'kafka://'           => 'retries=6&retry_backoff_ms=200'
    }

    # Custom URI scheme to pass events through map function
    $map_scheme        = 'map://'
    # The downstream eventlogging MySQL consumer expects schemas to be
    # all mixed up in a single stream.  We send processed events to a
    # 'mixed' kafka topic in order to keep supporting it for now.
    # We whitelist certain low volume schemas for this topic.
    # The whitelist is maintained in plugins.py.
    $valid_mixed_filter_function = 'eventlogging_valid_mixed_filter'

    # Incoming format from /beacon/event via varnishkafka eventlogging-client-side
    # is of the format:
    #   %q          - GET query with encoded event
    #   %{recvFrom} - recvFrom hostname
    #   %{seqId}    - sequence #
    #   %D          - ISO-8601 dt
    #   %o          - omit
    #   %u          - userAgent
    $format = '%q %{recvFrom}s %{seqId}d %D %{ip}i %u'
    eventlogging::service::processor { $client_side_processors:
        format         => $format,
        input          => $kafka_client_side_raw_uri,
        sid            => $kafka_consumer_group,
        outputs        => [
            "${kafka_schema_output_uri}&${kafka_producer_args}",
            "${map_scheme}${kafka_mixed_output_uri}&${kafka_producer_args}&function=${valid_mixed_filter_function}",
        ],
        output_invalid => true,
    }
}
