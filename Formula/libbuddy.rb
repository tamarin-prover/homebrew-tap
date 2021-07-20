class Libbuddy < Formula
  desc "Binary decision diagram library"
  homepage "https://sourceforge.net/projects/buddy/"
  url "https://downloads.sourceforge.net/project/buddy/buddy/BuDDy%202.4/buddy-2.4.tar.gz"
  sha256 "d3df80a6a669d9ae408cb46012ff17bd33d855529d20f3a7e563d0d913358836"

  bottle do
    root_url "https://raw.githubusercontent.com/tamarin-prover/binaries/HEAD/dependencies"
    rebuild 3
    sha256 cellar: :any_skip_relocation, big_sur:      "2d2c92c55832c9f6ba160cc9154542779a63ab111bb8bc668f295e776dc1ab9a"
    sha256 cellar: :any_skip_relocation, catalina:     "3cab96ab2fe4506669abd447bf5185e789ab0ea2a40536ff61b0b734f167f5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0807d5706dc37213dbc466b06819fc1b93d710c3543b92eec3c07e7c4fc317d5"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include "bvec.h"
      using namespace std;
      int main(void) {
        bdd_init(10, 10);
        bvec x = bvec(1);
        bvec c = bvec(1, 0);
        bdd t = x == c;
        cout << t;
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cc", "-I#{include}", "-L#{lib}", "-lbdd"
    assert_equal "T", shell_output("./test")
  end
end
