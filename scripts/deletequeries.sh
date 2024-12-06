#!/bin/bash                                 <aws:notify-dev>

    query_ids=(
        "fff2cf52-215b-4e38-a277-0b94c5aae381"
        "fcaa3ef4-2dd1-4537-9eba-569aff91b1b1"
        "ec301f4e-3bad-408a-be03-e151d63ec955"
        "e9ce9d13-5f56-438a-bb01-712c9ebc3d0a"
        "e8a34944-9f04-4141-b7b4-0e129d42dc59"
        "e2137f26-1d33-4934-a25b-ec86904f45bf"
        "de48c0eb-908d-4a05-8d55-1eea423e26af"
        "d17e8fb5-9161-4578-8fcb-36fa1384829f"
        "cf80773c-d22d-4ea0-ae16-a03c908b9b24"
        "b4c2d3ca-77f4-4967-978a-3feedfafb335"
        "b2401296-4b5f-4e1d-87ea-e4bc337462f8"
        "ae1acc16-73fc-4122-8fa4-ca68903fed16"
        "ab114ce6-1299-40cc-9879-3add98e24d22"
        "aa032ba3-8044-4e6b-836c-33df9cb783c3"
        "a4e3adc8-3455-4988-b66b-ba09832fc52b"
        "a3414d1b-2265-4170-86aa-38624cfcb5dc"
        "9e290fe6-2f2a-4b07-a2af-b1c59de049a7"
        "91e048c2-7e45-45cc-98f9-053c968c3d4b"
        "85fdada6-a266-43a5-8017-c1d5576400c6"
        "7820d441-fdee-4ffc-967b-5433ff3e58e7"
        "77ed0a92-9c88-4a02-8d7f-c9bb1ff636b1"
        "6d9e0b6f-2036-4342-b600-bf214c894806"
        "69bfa228-0118-4c85-b9b9-fddd2087ebc1"
        "6673d0f2-f316-4016-a5e2-a12e97ce1f77"
        "57ebdc6e-9d45-4cbb-9666-5f5bc93bb04a"
        "57097d3f-1b6e-4a8b-ada0-3a170c8eb27b"
        "5673205e-66f9-48ca-a54e-6f5c99440ac8"
        "5598b6ce-25c5-4f31-a284-98f4c69eb43c"
        "546942bc-2573-4713-bd3c-cf129b210191"
        "4ce1d267-4e88-4a54-abbb-6f9d81dd759f"
        "3ccf33ca-e067-4cc5-a7c6-3becbcdcee8d"
        "2e46434d-dc44-4123-ba1d-722296719fd5"
        "226169b4-5d35-4cb5-b25f-f1ffa37b8288"
        "1a056dc0-d8bc-480e-9dd4-b934e405e7bd"
        "17f324ff-efae-4156-9de5-71858149a83d"
        "179d2fe7-bee2-4761-a712-4f13aa9e1350"
        "15152f15-33c6-49b8-96b0-4f75e38f3c6d"
        "0412d9f1-24d3-4ca7-8418-461e8b1500df"
    )

    # Loop through each ID and delete the query definition
    for id in "${query_ids[@]}"; do
      echo "Deleting query definition with ID: $id"
      aws logs delete-query-definition --query-definition-id $id
    done

    echo "All specified query definitions have been deleted."