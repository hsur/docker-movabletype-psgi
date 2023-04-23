#!/bin/bash

MT_ARCHIVE=https://movabletype.org/downloads/stable/MTOS-5.2.13.tar.gz
WORK_DIR=./src/mt

mkdir -p $WORK_DIR
cp mt-config.cgi $WORK_DIR/
pushd $WORK_DIR
curl -O "$MT_ARCHIVE"
tar xf `basename "$MT_ARCHIVE"` --strip-components 1
pushd ../html
if [ ! -e mt-static ] ; then
  ln -s ../mt/mt-static .
fi
popd
popd

cat <<'EOF' | patch -p0
--- src/mt/lib/MT/App/CMS.pm.org     2015-04-02 15:24:58.000000000 +0900
+++ src/mt/lib/MT/App/CMS.pm    2023-04-22 16:36:14.978363401 +0900
@@ -4973,9 +4973,9 @@

     if ( my $blog = $app->blog ) {
         if ( my $css = $blog->content_css ) {
-            $css =~ s#{{support}}/?#$app->support_directory_url#ie;
+            $css =~ s#\{\{support\}\}/?#$app->support_directory_url#ie;
             if ( my $theme = $blog->theme ) {
-                $css =~ s#{{theme_static}}/?#$theme->static_file_url#ie;
+                $css =~ s#\{\{theme_static\}\}/?#$theme->static_file_url#ie;
             }
             if ( $css !~ m#\A(https?:)?/# ) {
                 $css = MT::Util::caturl( $blog->site_url, $css );
--- src/mt/extlib/URI/Escape.pm.org     2015-04-02 15:24:57.000000000 +0900
+++ src/mt/extlib/URI/Escape.pm 2023-04-22 16:52:59.518360933 +0900
@@ -212,7 +212,17 @@
 }

 sub escape_char {
-    return join '', @URI::Escape::escapes{$_[0] =~ /(\C)/g};
+    # Old versions of utf8::is_utf8() didn't properly handle magical vars (e.g. $1).
+    # The following forces a fetch to occur beforehand.
+    my $dummy = substr($_[0], 0, 0);
+
+    if (utf8::is_utf8($_[0])) {
+        my $s = shift;
+        utf8::encode($s);
+        unshift(@_, $s);
+    }
+
+    return join '', @URI::Escape::escapes{split //, $_[0]};
 }
EOF

