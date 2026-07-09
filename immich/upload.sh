docker run -it --rm \
  -v "/mnt/Memorabilia":/import:ro \
  -e IMMICH_INSTANCE_URL=http://photos.at.home/api \
  -e IMMICH_API_KEY=p8UuvhjnqnzhVnT0kh1YGE07sebYRuV0anx7eEYDnok \
  ghcr.io/immich-app/immich-cli:latest \
  upload --recursive --album "/import/ExportJuly26"
