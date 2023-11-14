# CCGMS & WiModem

**Commodore Color Graphics Manipulation System Terminal** by Craig Smith (1985-1988), alwyz (2017-2020), Michael Steil (2022).

Latest source code is at [mist64/ccgmsterm](https://github.com/mist64/ccgmsterm) along with the [Documentation](https://github.com/mist64/ccgmsterm/blob/main/Documentation.md).

## Usage with [WiModem](https://cbmstuff.com/forum)

1. Switch baud rate to 300 `F7 -> B -> RETURN`
2. Switch terms to ASCII Mode `F8`
3. View modem status `ATI` (case-sensitive)
4. Turn the brightness of the modem LED down `AT*LED2`
5. If necessary, update firmware `AT*UPDATE`
6. Change the baud of the modem `AT*B2400`
7. Switch the baud of CCGMS to match `F7 -> B -> RETURN`
8. Dial a BBS `ATDT bbs.8bitboyz.com:6502`
9. When you are done, hang up `ATH`

Note: This BBS doesn't work well on the C64. I just used it as an example as
I usually connect to it from my RC2014 system.

You can increase the baud rate to `4800` or `9600` by switching the Modem Type to `UP9600 / EZ232`. I found `9600` had a few errors so use `4800`.
