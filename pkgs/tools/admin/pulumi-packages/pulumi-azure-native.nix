{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-azure-native";
  version = "2.16.0";
  rev = "v${version}";
  hash = "sha256-QcJoJHcnjdctUg1632SP3YaQoQAPLkID5iRKRpNmfNo=";
  vendorHash = "sha256-TlMPNWjPDKJp9GIJc5LKlsMJAIX9Q8E1tD+QFMU48N4=";
  cmdGen = "pulumi-gen-azure-native";
  cmdRes = "pulumi-resource-azure-native";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/v2/provider/pkg/version.Version=${version}"
  ];
  postConfigure = ''
    pushd ..

    chmod +w . provider/cmd/${cmdRes} sdk/
    chmod -R +w reports/ versions/
    mkdir bin
    ${cmdGen} schema ${version}

    cp bin/schema-full.json provider/cmd/${cmdRes}
    cp bin/metadata-compact.json provider/cmd/${cmdRes}

    popd

    VERSION=v${version} go generate cmd/${cmdRes}/main.go
  '';
  fetchSubmodules = true;
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "Native Azure Pulumi Provider";
    mainProgram = "pulumi-resource-azure-native";
    homepage = "https://github.com/pulumi/pulumi-azure-native";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
