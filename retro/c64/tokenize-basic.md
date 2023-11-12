# Writing BASIC Files on the Computer and Transferring to the Commodore 64

The [VICE emulator](https://vice-emu.sourceforge.io/) includes a c1541 utility that can create d64 disk images.

On the C64, Basic programs are not stored as text. It's a tokenized version that is saved on disk. But VICE also includes `petcat` which does this for you.

So first you'll create a C64 disk image:

```sh
c1541 -format hello,dd d64 hello.d64
```

Then you'll write your basic program in a text file called `hello.bas` as

```sh
10 print "hello mac"
20 goto 10
```

Once that's done, you'll tokenize the program into a `prg` file:

```sh
petcat -v -w2 -o hello.prg -- hello.bas
```

And write that prg file to the C64 disk you created:

```sh
c1541 -attach hello.d64 -write hello.prg
```

And now you've got a C64 ready to be loaded onto your C64 using an [SD2IEC](SD2IEC.md), or you can test it in VICE using:

```sh
x64 hello.d64
```
