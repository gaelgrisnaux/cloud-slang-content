####################################################
#!!
#! @description: This flow is used to perform a REST Get request to any ServiceNow table.
#! @input host: required - The URL of the ServiceNow instance
#!              Format: scheme://domain
#!              Example: 'https://dev10000.service-now.com'
#! @input auth_type: optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input api_version: optional - the servicenow api version to be used for the call
#!                     Example: 'v1'
#! @input system_id: optional - The System ID of the item for which details should be returned. When this input is left empty, the flow returns the details of multiple items.
#!                   Example: 71c7ac460f811200ff7eb17ce1050e7a
#! @input table_name: required - the name of the servicenow table which should be used for the request.
#!                    Example: 'incident', 'change', 'request'
#! @input username: optional - The ServiceNow username used to perform the request.
#! @input password: optional - The ServiceNow password used to perform the request.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established - Default: '0' (infinite)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved - Default: '0' (infinite)
#! @input headers: optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:text/plain'
#! @input query_params: optional - list containing query parameters to append to the URL
#!                      Example: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'text/plain'
#! @output return_result: the response of the operation in case of success or the error message otherwise
#! @output error_message: return_result if status_code different than '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#!!#
################################################

namespace: io.cloudslang.service_now.commons

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: get_record

  inputs:
    - host
    - auth_type:
        required: false
        default: ''
    - api_version:
        required: false
        default: ''
    - table_name
    - system_id:
        required: false
        default: ''
    - username:
        required: false
        default: ''
    - password:
        required: false
        default: ''
    - proxy_host:
        required: false
        default: ''
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
        default: ''
    - proxy_password:
        required: false
        default: ''
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - headers:
        required: false
        default: ''
    - query_params:
        required: false
        default: ''
    - content_type:
        default: "application/json"
        required: false
        overridable: false

  workflow:
    - get_record:
        do:
          rest.http_client_get:
            - url: >
                ${host + '/api/now/' + api_version + '/table/' + table_name + ('/' + system_id if system_id !='' else '')}
            - auth_type
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
            - headers
            - query_params
            - content_type
        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
    - return_result
