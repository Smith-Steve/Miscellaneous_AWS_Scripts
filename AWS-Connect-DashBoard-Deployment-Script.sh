#!/bin/bash
echo This is a simple bash scripted designed to deploy AWS Dashboards to AWS Cloudwatch.
echo This script is dependent on the user having the required AWS permissions that are necessary to run this script.
echo It requires that you have the necessary AWS libraries installed on your computer.
echo Additionally, you are also required to log into the right AWS environment with your CLI. If you are not logged into the right environment
echo this will not work. If you are not logged into the right environment, please cancel running this and type in \'aws configure\'
echo Please enter the name of the client:
read clientName
fileName="${clientName}_Dashboard.json"
echo Please enter the clients\' instanceID/ARN:
read instanceId
echo Please enter the AWS region the client\'s call center is located in:
read instanceRegion
dashboardName="${clientName}-Call-Center-Monitoring-Dashboard"
touch "${clientName}_Dashboard.json"
cat <<EOF > "${fileName}"
{
    "start": "-PT3H",
    "periodOverride": "inherit",
    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Connect", "CallsPerInterval", "InstanceId", "${instanceId}", "MetricGroup", "VoiceCalls", { "visible": false } ],
                    [ ".", "ConcurrentCallsPercentage", ".", ".", ".", ".", { "visible": false } ],
                    [ ".", "ConcurrentCalls", ".", ".", ".", "." ],
                    [ ".", "MissedCalls", ".", ".", ".", ".", { "visible": false } ],
                    [ ".", "CallRecordingUploadError", ".", ".", ".", "CallRecordings", { "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${instanceRegion}",
                "title": "Concurrent Calls - Widget",
                "period": 300,
                "yAxis": {
                    "left": {
                        "label": "miliseconds",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "stat": "Average",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold",
                            "value": 120
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Connect", "ToInstancePacketLossRate", "Participant", "Agent", "Type of Connection", "WebRTC", "Instance ID", "${instanceId}", "Stream Type", "Voice", { "period": 60, "stat": "Average", "color": "#2ca02c" } ],
                    [ "...", { "period": 60, "stat": "Maximum", "color": "#d62728" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${instanceRegion}",
                "title": "Instance Packet Loss - Widget",
                "yAxis": {
                    "left": {
                        "label": "Packet",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "period": 300,
                "liveData": true,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold",
                            "value": 0.8
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Connect", "ConcurrentCallsPercentage", "InstanceId", "${instanceId}", "MetricGroup", "VoiceCalls", { "visible": false } ],
                    [ ".", "ConcurrentCalls", ".", ".", ".", ".", { "visible": false } ],
                    [ ".", "CallsPerInterval", ".", ".", ".", ".", { "visible": false } ],
                    [ ".", "MissedCalls", ".", ".", ".", "." ],
                    [ ".", "CallRecordingUploadError", ".", ".", ".", "CallRecordings", { "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${instanceRegion}",
                "title": "Missed Calls - Widget",
                "period": 300,
                "stat": "Average",
                "yAxis": {
                    "left": {
                        "label": "Calls",
                        "showUnits": false 
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm",
                            "value": 20
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/Lambda", "Errors", {"period": 60, "stat": "Sum", "color": "#d62728"} ]
                ],
                "region": "${instanceRegion}",
                "yAxis": {
                    "left": {
                        "label": "Errors",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold",
                            "value": 1
                        }
                    ]
                },
                "title": "Lambda Errors - Widget - Overall",
                "period": 300
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Duration", {"region": "${instanceRegion}", "color": "#ff9896", "label": "Duration"} ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${instanceRegion}",
                "period": 60,
                "yAxis": {
                    "left": {
                        "label": "Milliseconds",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "stat": "Sum",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold (15 Minutes)",
                            "value": 900000
                        }
                    ]
                },
                "title": "Lambda Execution Duration - Widget"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Connect", "CallsPerInterval", "InstanceId", "${instanceId}", "MetricGroup", "VoiceCalls", { "period": 3600, "stat": "Sum", "color": "#2ca02c" } ]
                ],
                "period": 300,
                "stat": "Sum",
                "yAxis": {
                    "left": {
                        "label": "Calls",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                }
                ,
                "region": "${instanceRegion}",
                "title": "Total Calls - Widget",
                "liveData": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 12,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "metrics": [
                    [ { "expression": "SEARCH('{AWS/Connect,ContactFlowName,InstanceId,MetricGroup}', 'Average', 300)", "id": "e1", "period": 300, "color": "#d62728" } ]
                ],
                "region": "${instanceRegion}",
                "period": 300,
                "yAxis": {
                    "left": {
                        "label": "Errors",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "title": "Contact Flow Errors - Widget - Overall"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 18,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ { "expression": "SEARCH('{AWS/Connect,QueueName, InstanceId, MetricGroup}', 'Average', 300)", "id": "e1", "period": 300, "region": "${instanceRegion}" } ]
                ],
                "region": "${instanceRegion}",
                "title": "Queue Wait Time - Widget - By Queue",
                "period": 300,
                "yAxis": {
                    "left": {
                        "label": "Seconds in Queue",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold",
                            "value": 600,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 5,
            "width": 24,
            "y": 12,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "singleValue",
                "stacked": false,
                "metrics": [
                    [ { "expression": "SEARCH('{AWS/Connect,QueueName, InstanceId, MetricGroup}', 'Average', 300)", "id": "e1", "period": 300, "region": "${instanceRegion}" } ]
                ],
                "region": "${instanceRegion}",
                "title": "Queue Wait Time - Widget - By Queue",
                "period": 300,
                "yAxis": {
                    "left": {
                        "label": "Seconds In Queue",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold",
                            "value": 600,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 5,
            "width": 6,
            "type": "metric",
            "x": 0,
            "y": 17,
            "properties": {
                "metrics": [
                    [ { "expression": "SELECT SUM(Errors) FROM SCHEMA(\"AWS/Lambda\", FunctionName) GROUP BY FunctionName", "label": "Lambda", "id": "q1", "region": "${instanceRegion}", "period": 60, "stat": "Sum" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-west-2",
                "title": "Lambda Errors - Widget - By Lambda",
                "period": 60,
                "yAxis": {
                    "left": {
                        "label": "Errors",
                        "showUnits": false
                    },
                    "right": {
                        "label": "Time",
                        "showUnits": false
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Alarm Threshold",
                            "value": 600,
                            "fill": "above"
                        }
                    ]
                },
                "stat": "Sum"
            }
        }
    ]
}
EOF
fileName="file://${fileName}"
echo $fileName
aws cloudwatch put-dashboard --dashboard-name $dashboardName --dashboard-body $fileName --output json
aws cloudwatch put-metric-alarm --alarm-name "Concurrent Calls - Alarm - All Calls" --alarm-description "Call Center Concurrent Calls" --metric-name ConcurrentCalls --namespace AWS/Connect --statistic Sum --period 300 --threshold 250 --comparison-operator GreaterThanThreshold --evaluation-periods 2 --unit Count
aws cloudwatch put-metric-alarm --alarm-name "Lambda Errors - Alarm - All Lambdas" --alarm-description "Alarm for Lambda Errors" --metric-name Errors --namespace AWS/Lambda --statistic Sum --period 300 --unit Count --evaluation-periods 1 --datapoints-to-alarm 1 --threshold 10 --comparison-operator GreaterThanOrEqualToThreshold --treat-missing-data ignore
aws cloudwatch put-metric-alarm --alarm-name "Lambda Execution Duration - Alarm - Overall" --alarm-description "Alarm for detecting when Lambdas have been running too long." --metric-name Duration --namespace AWS/Lambda --statistic Sum --period 300 --threshold 900 --comparison-operator GreaterThanThreshold --evaluation-periods 1 --treat-missing-data missing
aws cloudwatch put-metric-alarm --alarm-name "Instance Packet Loss - Alarm" --alarm-description "Call center alarm for monitoring when one or more transmitted data packets fail to arrive at their destination" --metric-name ToInstancePacketLoss --namespace AWS/Connect --statistic Average --dimensions '[{"Name":"Participant","Value":"Agent"},{"Name":"Type of Connection","Value":"WebRTC"},{"Name":"Instance ID","Value":"${instanceId}"},{"Name":"Stream Type","Value":"Voice"}]' --period 300 --threshold 0.95 --datapoints-to-alarm 1 --comparison-operator GreaterThanThreshold --evaluation-periods 1 --treat-missing-data missing
aws cloudwatch put-metric-alarm --alarm-name "Missed Calls - Alarm" --alarm-description "Call center alarm for monitoring missed calls within designated period." --metric-name MissedCalls --namespace AWS/Connect --statistic Maximum --dimensions '[{"Name":"MetricGroup","Value":"VoiceCalls"},{"Name":"InstanceId","Value":"${instanceId}"}]' --period 300 --evaluation-periods 1 --datapoints-to-alarm 1 --threshold 20 --comparison-operator GreaterThanOrEqualToThreshold --treat-missing-data ignore
