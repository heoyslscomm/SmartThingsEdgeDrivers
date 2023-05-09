-- Copyright 2022 SmartThings
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- Mock out globals
local test = require "integration_test"
local clusters = require "st.zigbee.zcl.clusters"
local OnOff = clusters.OnOff
local capabilities = require "st.capabilities"
local zigbee_test_utils = require "integration_test.zigbee_test_utils"
local t_utils = require "integration_test.utils"
local profile_def = t_utils.get_profile_definition("basic-switch-no-firmware-update.yml")

local mock_parent_device = test.mock_device.build_test_zigbee_device(
  {
    profile = profile_def,
    fingerprinted_endpoint_id = 0x01
  }
)

local mock_first_child = test.mock_device.build_test_child_device(
  {
    profile = profile_def,
    parent_device_id = mock_parent_device.id,
    parent_assigned_child_key = string.format("%02X", 2)
  }
)

local mock_second_child = test.mock_device.build_test_child_device(
  {
    profile = profile_def,
    parent_device_id = mock_parent_device.id,
    parent_assigned_child_key = string.format("%02X", 3)
  }
)

local mock_third_child = test.mock_device.build_test_child_device(
  {
    profile = profile_def,
    parent_device_id = mock_parent_device.id,
    parent_assigned_child_key = string.format("%02X", 4)
  }
)

local mock_fourth_child = test.mock_device.build_test_child_device(
  {
    profile = profile_def,
    parent_device_id = mock_parent_device.id,
    parent_assigned_child_key = string.format("%02X", 5)
  }
)

local mock_fifth_child = test.mock_device.build_test_child_device(
  {
    profile = profile_def,
    parent_device_id = mock_parent_device.id,
    parent_assigned_child_key = string.format("%02X", 6)
  }
)

zigbee_test_utils.prepare_zigbee_env_info()

local function test_init()
  test.mock_device.add_test_device(mock_parent_device)
  test.mock_device.add_test_device(mock_first_child)
  test.mock_device.add_test_device(mock_second_child)
  test.mock_device.add_test_device(mock_third_child)
  test.mock_device.add_test_device(mock_fourth_child)
  test.mock_device.add_test_device(mock_fifth_child)

  zigbee_test_utils.init_noop_health_check_timer()
end

test.set_test_init_function(test_init)

test.register_message_test(
    "Reported on off status should be handled by parent device: on",
    {
      --[[
      {
        channel = "device_lifecycle",
        direction = "receive",
        message = { mock_parent_device.id, "init" }
      },
      ]]
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_parent_device.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            true)                               :from_endpoint(0x01) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_parent_device:generate_test_message("main", capabilities.switch.switch.on())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by first child device: on",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_first_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            true)                             :from_endpoint(0x02) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_first_child:generate_test_message("main", capabilities.switch.switch.on())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by Second child device: on",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_second_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            true)                              :from_endpoint(0x03) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_second_child:generate_test_message("main", capabilities.switch.switch.on())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by third child device: on",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_third_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            true)                              :from_endpoint(0x04) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_third_child:generate_test_message("main", capabilities.switch.switch.on())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by fourth child device: on",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_fourth_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            true)                              :from_endpoint(0x05) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_fourth_child:generate_test_message("main", capabilities.switch.switch.on())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by fifth child device: on",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_fifth_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            true)                              :from_endpoint(0x06) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_fifth_child:generate_test_message("main", capabilities.switch.switch.on())
      }
    }
)

test.register_message_test(
    "reported on off status should be handled by parent device: off",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_parent_device.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
            false)                               :from_endpoint(0x01) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_parent_device:generate_test_message("main", capabilities.switch.switch.off())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by first child device: off",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_first_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
        false)                             :from_endpoint(0x02) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_first_child:generate_test_message("main", capabilities.switch.switch.off())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by Second child device: off",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_second_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
        false)                              :from_endpoint(0x03) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_second_child:generate_test_message("main", capabilities.switch.switch.off())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by third child device: off",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_third_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
        false)                              :from_endpoint(0x04) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_third_child:generate_test_message("main", capabilities.switch.switch.off())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by fourth child device: off",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_fourth_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
        false)                              :from_endpoint(0x05) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_fourth_child:generate_test_message("main", capabilities.switch.switch.off())
      }
    }
)

test.register_message_test(
    "Reported on off status should be handled by fifth child device: off",
    {
      {
        channel = "zigbee",
        direction = "receive",
        message = { mock_fifth_child.id, OnOff.attributes.OnOff:build_test_attr_report(mock_parent_device,
        false)                              :from_endpoint(0x06) }
      },
      {
        channel = "capability",
        direction = "send",
        message = mock_fifth_child:generate_test_message("main", capabilities.switch.switch.off())
      }
    }
)

test.register_message_test(
    "Capability on command switch on should be handled : parent device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_parent_device.id, { capability = "switch", component = "main", command = "on", args = { } } }
      },
     
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.On(mock_parent_device):to_endpoint(0x01) }
      }
    }
)

test.register_message_test(
    "Capability on command switch on should be handled : first child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_first_child.id, { capability = "switch", component = "main", command = "on", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.On(mock_parent_device):to_endpoint(0x02) }
      }
    }
)

test.register_message_test(
    "Capability on command switch on should be handled : second child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_second_child.id, { capability = "switch", component = "main", command = "on", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.On(mock_parent_device):to_endpoint(0x03) }
      }
    }
)

test.register_message_test(
    "Capability on command switch on should be handled : third child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_third_child.id, { capability = "switch", component = "main", command = "on", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.On(mock_parent_device):to_endpoint(0x04) }
      }
    }
)

test.register_message_test(
    "Capability on command switch on should be handled : fourth child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_fourth_child.id, { capability = "switch", component = "main", command = "on", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.On(mock_parent_device):to_endpoint(0x05) }
      }
    }
)

test.register_message_test(
    "Capability on command switch on should be handled : fifth child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_fifth_child.id, { capability = "switch", component = "main", command = "on", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.On(mock_parent_device):to_endpoint(0x06) }
      }
    }
)

test.register_message_test(
    "Capability off command switch off should be handled : parent device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_parent_device.id, { capability = "switch", component = "main", command = "off", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.Off(mock_parent_device):to_endpoint(0x01) }
      }
    }
)

test.register_message_test(
    "Capability off command switch off should be handled : first child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_first_child.id, { capability = "switch", component = "main", command = "off", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.Off(mock_parent_device):to_endpoint(0x02) }
      }
    }
)

test.register_message_test(
    "Capability off command switch off should be handled : second child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_second_child.id, { capability = "switch", component = "main", command = "off", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.Off(mock_parent_device):to_endpoint(0x03) }
      }
    }
)

test.register_message_test(
    "Capability off command switch off should be handled : third child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_third_child.id, { capability = "switch", component = "main", command = "off", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.Off(mock_parent_device):to_endpoint(0x04) }
      }
    }
)

test.register_message_test(
    "Capability off command switch off should be handled : fourth child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_fourth_child.id, { capability = "switch", component = "main", command = "off", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.Off(mock_parent_device):to_endpoint(0x05) }
      }
    }
)

test.register_message_test(
    "Capability off command switch off should be handled : fifth child device",
    {
      {
        channel = "capability",
        direction = "receive",
        message = { mock_fifth_child.id, { capability = "switch", component = "main", command = "off", args = { } } }
      },
      {
        channel = "zigbee",
        direction = "send",
        message = { mock_parent_device.id, OnOff.server.commands.Off(mock_parent_device):to_endpoint(0x06) }
      }
    }
)

test.run_registered_tests()