# You Only Die Once

This is game I made for
https://itch.io/jam/pursuing-pixels-james-jam-game-gam

To launch this game you'll need to download Taylor http://taylor.oequacki.com/
and then you can just call `./taylor` from inside the folder.


## Notes

Since this is game jam code it's a bit messy, there's some TODO around the place
for things that I'm not super happy about, but I am pleased with how
`lib/input.rb` is coming along as one of my goals for this project was to see if
I could come up with a decent generic input wrapper. With a little more work I
can see this being quite polished.

The web export will probably break in the future. I added the
`local_storage_set_item` and `local_storage_get_item` during this jam but will
probably change them to be a little nicer, something like `LocalStorage.get` and
`LocalStorage.set`.
