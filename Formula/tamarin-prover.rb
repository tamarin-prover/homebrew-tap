class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.2.3.tar.gz"
  sha256 "9b637460cbadd826d8a2cdb324b660b47c6a27ff4df32e820925018c16f67796"
  head "https://github.com/tamarin-prover/tamarin-prover.git", :branch => "develop"

  depends_on "haskell-stack" => :build
  depends_on "ocaml" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "maude"
  depends_on "graphviz"
  depends_on :macos => :mountain_lion

  bottle do
    root_url "https://dl.bintray.com/katriel/tamarin-prover"
    cellar :any_skip_relocation
    sha256 "c530417ab4ce6901fc08dd198793ddd281bbad7892c61fe6d82da71e21e88f12" => :high_sierra
  end

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    # Deparallelization prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
    ENV.deparallelize
    jobs = ENV.make_jobs
    system "stack", "-j#{jobs}", "setup"
    args = []
    args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}" unless OS.mac?
    system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"
    system "make", "sapic"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end
