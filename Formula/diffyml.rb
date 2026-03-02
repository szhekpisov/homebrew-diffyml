class Diffyml < Formula
  desc "Structural diff tool for YAML files"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e03d1faf2ff72b6319fb31f648827918a7cc976770c2135a542826a66b56a1fe"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffyml --version")

    (testpath/"file1.yaml").write <<~YAML
      name: test
      value: 1
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: test
      value: 2
    YAML

    output = shell_output("#{bin}/diffyml #{testpath}/file1.yaml #{testpath}/file2.yaml")
    assert_match "value", output
  end
end
