//
//
// Copyright 2016 gRPC authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

#ifndef GRPC_SRC_CORE_CLIENT_CHANNEL_HTTP_PROXY_MAPPER_H
#define GRPC_SRC_CORE_CLIENT_CHANNEL_HTTP_PROXY_MAPPER_H

#include <grpc/support/port_platform.h>

#include <string>

#include "absl/strings/string_view.h"
#include "absl/types/optional.h"

#include "src/core/lib/channel/channel_args.h"
#include "src/core/lib/config/core_configuration.h"
#include "src/core/lib/handshaker/proxy_mapper.h"
#include "src/core/lib/iomgr/resolved_address.h"

namespace grpc_core {

class HttpProxyMapper : public ProxyMapperInterface {
 public:
  static constexpr char const* kAddressProxyEnvVar = "GRPC_ADDRESS_HTTP_PROXY";
  static constexpr char const* kAddressProxyEnabledAddressesEnvVar =
      "GRPC_ADDRESS_HTTP_PROXY_ENABLED_ADDRESSES";

  absl::optional<std::string> MapName(absl::string_view server_uri,
                                      ChannelArgs* args) override;

  absl::optional<grpc_resolved_address> MapAddress(
      const grpc_resolved_address& address, ChannelArgs* args) override;
};

void RegisterHttpProxyMapper(CoreConfiguration::Builder* builder);

}  // namespace grpc_core

#endif  // GRPC_SRC_CORE_CLIENT_CHANNEL_HTTP_PROXY_MAPPER_H
