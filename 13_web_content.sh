url="https://www.python.org/downloads/"

# content=$(wget $url -q -O -)
# echo $content | grep -i ".tar.xz"

# content=$(curl -L $url)
# echo $content | grep -i ".tar.xz"

lynx -dump $url | grep -i ".tar.xz"