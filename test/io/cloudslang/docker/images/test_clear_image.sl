#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  strings: io.cloudslang.base.strings
  maintenance: io.cloudslang.docker.maintenance

flow:
  name: test_clear_image
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name

  workflow:
    - clear_docker_host:
        do:
          maintenance.clear_host:
            - docker_host: ${ host }
            - port
            - docker_username: ${ username }
            - docker_password: ${ password }
        navigate:
          - SUCCESS: pull_image
          - FAILURE: CLEAR_DOCKER_HOST_FAILURE

    - pull_image:
        do:
          images.test_pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          - SUCCESS: get_all_images_after
          - MACHINE_IS_NOT_CLEAN: MACHINE_IS_NOT_CLEAN
          - FAIL_PULL_IMAGE: FAIL_PULL_IMAGE
          - FAIL_GET_ALL_IMAGES: FAIL_GET_ALL_IMAGES
          - FAILURE: FAILURE

    - get_all_images_after:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
        publish:
          - image_list
        navigate:
          - SUCCESS: validate_image_cleared
          - FAILURE: FAIL_GET_ALL_IMAGES

    - validate_image_cleared:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ image_list }
            - string_to_find: ${ image_name }
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: SUCCESS

  results:
    - SUCCESS
    - CLEAR_DOCKER_HOST_FAILURE
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAIL_GET_ALL_IMAGES
    - FAILURE
