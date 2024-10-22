# Set the GPU Affinity of Ollama on Windows

I want to ensure that `ollama` runs on my dedicated NVidia GPU instead of my integrated Intel GPU.

1. Open Windows Settings
2. Search for Graphics
3. Under 'Custom options for apps', add a desktop app,
4. Navigate to `C:\Users\{username}\AppData\Local\Programs\Ollama`
5. Add `ollama.exe`,
6. It will appear in the list below, click `Options` and select `High performance`.

Not sure if it is needed, but I did the same for `ollama app.exe`.
