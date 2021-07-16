class Maude < Formula
  desc "Reflective language for equational and rewriting logic specification"
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.illinois.edu/w/images/d/d8/Maude-2.7.1.tar.gz"
  sha256 "b1887c7fa75e85a1526467727242f77b5ec7cd6a5dfa4ceb686b6f545bb1534b"
  revision 1

  bottle do
    root_url "https://github.com/tamarin-prover/binaries/blob/main/dependencies"
    sha256 cellar: :any, big_sur:      "85df799f6d20b0425a13c22e22cb6da1d054251f595f429aaa026d1dd50b0a32"
    sha256 cellar: :any, mojave:       "120e8e9c8a83bfa0787b2e0b8f3ae798c18efd5db99e55a6a6ed3f37b56b820b"
    sha256 cellar: :any, high_sierra:  "747d2709c2e8db7b5aaca5b0ca8e200a596052606a31bb970b3823524a98e2b5"
    sha256 cellar: :any, sierra:       "952d23e1f143bfb62e21fb4b0e1b440dcfc431cc7250f458c4c1ecf7234fea5e"
    sha256 cellar: :any, el_capitan:   "042a617f84cacfdd0d8f441fcf1209fe6bef76483b0cf848bded5dc378f82bc6"
    sha256 cellar: :any, yosemite:     "8bb72b9a8f9097656ffb4f70f7b7addb2ba2a888134af1bd96b488340d25aadc"
    sha256 cellar: :any, x86_64_linux: "e341985f51abe73a4516690daf2b5bf384286b2f48414b79108cc9933187e014"
  end

  depends_on "gmp"
  depends_on "libbuddy"
  depends_on "libsigsegv"
  depends_on "libtecla"
  depends_on "flex" unless OS.mac?
  depends_on "bison" unless OS.mac?

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--without-cvc4"
    system "make", "install"
    (bin/"maude").write_env_script libexec/"bin/maude", MAUDE_LIB: libexec/"share"
  end

  test do
    input = <<~EOS
      set show stats off .
      set show timing off .
      set show command off .
      reduce in STRING : "hello" + " " + "world" .
    EOS
    expect = %Q(Maude> result String: "hello world"\nMaude> Bye.\n)
    output = pipe_output("#{bin/"maude"} -no-banner", input)
    assert_equal expect, output
  end
end
