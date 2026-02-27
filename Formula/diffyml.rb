class Diffyml < Formula
  desc "Structural diff tool for YAML files"
  homepage "https://github.com/szhekpisov/diffyml"
  url "https://github.com/szhekpisov/diffyml/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "f208572fc0cc2d7d7aad9259b7eac44021b40e88ce18a1a734b39fecac2a0f97"
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
