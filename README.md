# dyslexic.vim

`dyslexic.vim` is a Vim plugin that helps you find mistyped text by searching
for `word` permutations.

![dyslexic](https://cloud.githubusercontent.com/assets/111942/15996809/0f767d6c-30fa-11e6-9070-55ca30a2da01.gif)


## Usage

When your cursor is over a **known and correct** word (`<cword>`, actually),
press `<localleader>*` to highlight permutations.  If you get a message that
says there's no matches, you're done.  If there are matches, the
`location-list` window will open to list all matches in the current buffer.
You will have to go through the list and determine which ones are actually
incorrect.

There is a also a `:DyslexicTracking` command which will highlight matches as
the cursor is moved, but the `location-list` will remain hidden.  Calling the
command again or pressing `<localleader>*` will turn off cursor tracking.


## How it works

Suppose you are checking the word `var`.  The following pattern will be created
to search for permutations:

```
\<\%(avr\|vra\|ar\|vr\|va\|[^v]ar\|v[^a]r\|va[^r]\|v\k\{1,2}ar\|va\k\{1,2}r\|var\k\{1,2}\)\>
```

It searches for transposed or missing characters, and looks for 1-2 extra
characters between each character in `var`.

This would cause the word `not` to match `no` or `note`, which may not be
mistyped.  This is the reason you have to verify the results yourself.

**Note**: The pattern can get pretty big with long words.  This was not tested
for pattern length limits or performance.


## Support

It's okay.  We all have bad days and make mistakes.  Don't beat yourself up.

Hang in there, champ!


## License

The MIT License
Copyright (c) 2016 Tommy Allen

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
