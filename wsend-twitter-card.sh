#!/bin/bash
#
# Copyright 2013 Abraham Massry
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
#

userPic="$1"
dirname="wsend_twitter_card_temp_dir"
mkdir "$dirname"
commandLineImage="${userPic// /_}"
cp "$userPic" "$dirname/$commandLineImage"
image="$dirname/$commandLineImage"
extension="${image##*.}"
filename="${image%.*}"
if [ "$extension" == "png" ] || [ "$extension" == "jpg" ]; then
  clientOS=`uname`
  if [ "$clientOS" == "Darwin" ]; then
    fileToSendSize=$(stat -f %z "$image")
  else
    fileToSendSize=$(stat -c%s "$image")
  fi
  if [ $fileToSendSize -lt 999999 ]; then
    imageURL=`~/.wsend/wsend $image`
    echo '<!DOCTYPE html>' > "$dirname/index.html"
    echo '<html>' >> "$dirname/index.html"
    echo '<meta charset="utf-8">' >> "$dirname/index.html"
    echo '<link rel="icon" href="https://wsend.net/img/favicon.png">' >> "$dirname/index.html"
    echo '<title>wsend</title>' >> "$dirname/index.html"
    echo '<style>' >> "$dirname/index.html"
    echo 'img {' >> "$dirname/index.html"
    echo 'position: absolute;' >> "$dirname/index.html"
    echo 'height: 100%;' >> "$dirname/index.html"
    echo 'top: 0px;' >> "$dirname/index.html"
    echo 'left: 0px;' >> "$dirname/index.html"
    echo '}' >> "$dirname/index.html"
    echo '</style>' >> "$dirname/index.html"
    echo '</head>' >> "$dirname/index.html"
    echo '<body>' >> "$dirname/index.html"
    echo '<meta name="twitter:card" content="photo">' >> "$dirname/index.html"
    echo '<meta name="twitter:site" content="@wsendnet">' >> "$dirname/index.html"
    echo '<meta name="twitter:creator" content="@wsendnet">' >> "$dirname/index.html"
    echo '<meta name="twitter:title" content="wsend">' >> "$dirname/index.html"
    echo "<meta name='twitter:image' content='$imageURL'>" >> "$dirname/index.html"
    echo '<meta name="twitter:image:width" content="610">' >> "$dirname/index.html"
    echo '<meta name="twitter:image:height" content="610">' >> "$dirname/index.html"
    echo "<a href='$imageURL'>" >> "$dirname/index.html"
    echo "<img src='$imageURL' />" >> "$dirname/index.html"
    echo '</a>' >> "$dirname/index.html"
    echo '</body>' >> "$dirname/index.html"
    echo '</html>' >> "$dirname/index.html"
    twitterCardURL=`~/.wsend/wsend "$dirname/index.html"`
    echo "successfully uploaded at:"
    echo ""
    echo $twitterCardURL
    echo ""
    rm $image
    rm "$dirname/index.html"
    rmdir "$dirname"
  else
    echo "file size too large, must be under 1MB"
  fi
else
  echo "untested filetype, jpg and png are the only tested filetypes"
fi
