class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.4.1.tar.gz"
  sha256 "d0e95d738060d44bcce698877cc56c34ec61de1ca73d50d5d8a7a35ade990400"
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  depends_on "haskell-stack" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "ocaml" => :build
  depends_on "graphviz"
  depends_on :macos => :mountain_lion
  depends_on "maude"

  bottle do
    root_url "https://dl.bintray.com/tamarin-prover-org/tamarin-prover"
    cellar :any_skip_relocation
    # Looking at docs might be able to use :sierra_or_later
    sha256 "694ee78a3828a6f0f26902d49902abc8d46ad2877870a2bc07bfdeb156b9f509" => :high_sierra
    sha256 "ff644b9cde0c9d789770dffe55e5204d3ae9678565da5a529aa758ea202c1d14" => :mojave
    sha256 "6c5d2ec9fb7304e396d68c75405cfc37aa97f695f2519b5b87f64713167fb62b" => :x86_64_linux
  end

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    system "stack", "-j#{jobs}", "setup"
    args = []
    args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}" unless OS.mac?
    system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"

    # `ocaml` building under linuxbrew needs to be single core.
    ENV.deparallelize
    system "make", "sapic"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end
