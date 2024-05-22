# Packet Reassembly in Wireshark

TCP and other network protocols send larger data broken up into multiple packets. This makes it difficult to view the entire payload by just viewing the data segment of an individual packet. Wireshark makes it easy to see the entire payload. They call this [Packet Rassembly](https://www.wireshark.org/docs/wsug_html_chunked/ChAdvReassemblySection.html).

1. When viewing a capture in Wireshark, **right-click** on any packet in a sequence.
2. Under the **Follow** menu, it will show options for TCP, UDP, HTTP, etc depending on the protocol.
3. Select the stream option you are interested in. It will open a new window.
4. The new window will show and follow the data as it comes in.

Dropdowns at the bottom of the window will allow you to filter data and display it in different formats.
