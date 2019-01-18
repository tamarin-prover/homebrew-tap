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
    sha256 "c4e2c37ee3823670e6fcff47e48722b0f9406585b6a059a40251b2cd214f7513" => :mojave
    sha256 "da3bba52d6f0ff69b6d4a818044d02473ca494051272cd628b4418cb361af59e" => :high_sierra
    sha256 "1571c86decfb34621b20fe3a60bd675b62b34699c59d83ae30dc91bf47d2738c" => :x86_64_linux
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
