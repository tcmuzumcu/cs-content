#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Adds two numbers as floating point values.
#!
#! @input value1: First value as number or string.
#! @input value2: Second value as number or string.
#! @input input11: Second value as number or string.
#!
#! @output result: Operation result or reason for failure.
#! @output return_code: Operation return code ('0' or '-1').
#! @output test_result: Operation return code ('0' or '-1').
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: The operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.hcm.aws_service_catalog.utils

operation:
  name: add_numbers

  inputs:
    - value1
    - value2
#    - input11:
#        required: false
#        default: ''
#        sensitive: true

  python_action:
    script: |
      try:
        from java.math import BigDecimal,MathContext
        from java.lang import Exception as JavaException
        value1 = BigDecimal(value1, MathContext.DECIMAL64)
        value2 = BigDecimal(value2, MathContext.DECIMAL64)
        result = value1.add(value2, MathContext.DECIMAL64).stripTrailingZeros().toPlainString()
        return_code = '0'
      except JavaException as je:
        return_code = '-1'
        result = "Invalid number format"
      except Exception as e:
        return_code = '-1'
        result = e

  outputs:
     - result
     - return_code
#     - test_result: '${result + input11}'
     - teadjsfgsldjkr11:
         value: '${result}'
         sensitive: true

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE