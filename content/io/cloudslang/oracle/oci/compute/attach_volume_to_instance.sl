#   (c) Copyright 2020 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Attaches the specified storage volume to the specified instance.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is ID of the tenancy.
#! @input user_ocid: ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: Finger print of the public key generated for OCI account.
#! @input private_key_data: A string representing the private key for the OCI. This string is usually the content of a
#!                          private key file.
#!                          Optional
#! @input private_key_file: The path to the private key file on the machine where is the worker.
#!                          Optional
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#! @input instance_id: The OCID of the instance.
#! @input volume_id: The OCID of the volume.
#! @input volume_type: The type of volume.
#!                     Allowed values: ''iscsi' and 'paravirtualized''.
#! @input device_name: The device name.
#!                     Optional
#! @input display_name: A user-friendly name. Does not have to be unique, and it cannot be changed. Avoid entering
#!                      confidential information.
#!                      Optional
#! @input is_read_only: Whether the attachment was created in read-only mode.
#!                      Optional
#! @input is_shareable: Whether the attachment should be created in shareable mode. If an attachment is created in
#!                      shareable mode, then other instances can attach the same volume, provided that they also create
#!                      their attachments in shareable mode. Only certain volume types can be attached in shareable
#!                      mode. Defaults to false if not specified.
#!                      Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if theserver requires client
#!                  authentication. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                  'true' this input is ignored. Format: Java KeyStore (JKS)Default:
#!                  <OO_Home>/java/lib/security/cacerts
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trustAllRoots is false and keystore is
#!                           empty, keystorePassword default will be supplied.Default: changeit
#!                           Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close
#!                    it.Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.Default: '20'
#!                               Optional
#! @input response_character_set: The character encoding to be used for the HTTP response. If responseCharacterSet is
#!                                empty, the charset from the 'Content-Type' HTTP response header will be used. If
#!                                responseCharacterSet is empty and the charset from the HTTP response Content-Type
#!                                header is empty, the default value will be used. You should not use this for
#!                                method=HEAD or OPTIONS.Default: 'UTF-8'
#!                                Optional
#! @input retry_count: Number of checks if the instance was created successfully.
#!                     Default: '30'
#!                     Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output volume_attachment_id: The OCID of the volume attachment.
#! @output volume_attachment_state: The current state of the volume attachment.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: attach_volume_to_instance
  inputs:
    - tenancy_ocid
    - user_ocid
    - finger_print:
        sensitive: true
    - private_key_data:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - api_version:
        required: false
    - region
    - instance_id
    - volume_id
    - volume_type
    - device_name:
        required: false
    - display_name:
        required: false
    - is_read_only:
        required: false
    - is_shareable:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        required: false
    - x_509_hostname_verifier:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - response_character_set:
        required: false
    - retry_count:
        default: '30'
        required: false
  workflow:
    - attach_volume:
        do:
          io.cloudslang.oracle.oci.compute.volumes.attach_volume:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_data:
                value: '${private_key_data}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - volume_id: '${volume_id}'
            - volume_type: '${volume_type}'
            - device_name: '${device_name}'
            - display_name: '${display_name}'
            - is_read_only: '${is_read_only}'
            - is_shareable: '${is_shareable}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - volume_attachment_id: '${volume_attachment_id}'
          - volume_attachment_state: '${volume_attachment_state}'
        navigate:
          - SUCCESS: get_volume_attachment_details
          - FAILURE: on_failure
    - is_volume_attached:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${volume_attachment_state}'
            - second_string: ATTACHED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: wait_for_volume_to_attach
    - counter:
        do:
          io.cloudslang.oracle.oci.utils.counter:
            - from: '1'
            - to: '${retry_count}'
            - increment_by: '1'
        navigate:
          - HAS_MORE: get_volume_attachment_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_volume_to_attach:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_volume_attachment_details:
        do:
          io.cloudslang.oracle.oci.compute.volumes.get_volume_attachment_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_data:
                value: '${private_key_data}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - volume_attachment_id: '${volume_attachment_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - return_result: '${return_result}'
          - volume_attachment_state: '${volume_attachment_state}'
        navigate:
          - SUCCESS: is_volume_attached
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - volume_attachment_id: '${volume_attachment_id}'
    - volume_attachment_state: '${volume_attachment_state}'
  results:
    - FAILURE
    - SUCCESS
