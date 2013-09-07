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

commandLineImage="$1"
image=${commandLineImage// /_}
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
    mkdir "$filename"
    imageURL=`~/.wsend/wsend $image`
    echo '<!DOCTYPE html>' > "$filename/index.html"
    echo '<html>' >> "$filename/index.html"
    echo '<meta charset="utf-8">' >> "$filename/index.html"
    echo '<link rel="icon" href="https://wsend.net/img/favicon.png">' >> "$filename/index.html"
    echo '<title>wsend</title>' >> "$filename/index.html"
    echo '<style>' >> "$filename/index.html"
    echo 'img {' >> "$filename/index.html"
    echo 'position: absolute;' >> "$filename/index.html"
    echo 'height: 100%;' >> "$filename/index.html"
    echo 'top: 0px;' >> "$filename/index.html"
    echo 'left: 0px;' >> "$filename/index.html"
    echo '}' >> "$filename/index.html"
    echo '</style>' >> "$filename/index.html"
    echo '</head>' >> "$filename/index.html"
    echo '<body>' >> "$filename/index.html"
    echo '<meta name="twitter:card" content="photo">' >> "$filename/index.html"
    echo '<meta name="twitter:site" content="@wsendnet">' >> "$filename/index.html"
    echo '<meta name="twitter:creator" content="@wsendnet">' >> "$filename/index.html"
    echo '<meta name="twitter:title" content="wsend">' >> "$filename/index.html"
    echo "<meta name='twitter:image' content='$imageURL'>" >> "$filename/index.html"
    echo '<meta name="twitter:image:width" content="610">' >> "$filename/index.html"
    echo '<meta name="twitter:image:height" content="610">' >> "$filename/index.html"
    echo "<a href='$imageURL'>" >> "$filename/index.html"
    echo "<img src='$imageURL' />" >> "$filename/index.html"
    echo '</a>' >> "$filename/index.html"
    echo '</body>' >> "$filename/index.html"
    echo '</html>' >> "$filename/index.html"
    twitterCardURL=`~/.wsend/wsend "$filename/index.html"`
    echo "successfully uploaded at:"
    echo ""
    echo $twitterCardURL
    echo ""
    rm "$filename/index.html"
    rmdir "$filename"
  else
    echo "file size too large, must be under 1MB"
  fi
else
  echo "untested filetype, jpg and png are the only tested filetypes"
fi
