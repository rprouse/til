# Install Nerd Fonts on Linux

```sh
#!/bin/bash

declare -a fonts=(
    BigBlueTerminal
    CascadiaCode
    DejaVuSansMono
    DroidSansMono
    FiraCode
    Hack
    Hermit
    Inconsolata
    JetBrainsMono
    Meslo
    RobotoMono
    Ubuntu
    UbuntuMono
)

version='3.2.1'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip -o "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
```
