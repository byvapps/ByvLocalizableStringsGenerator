# ByvLocalizableStringsGenerator

## Requirements

This generator use [sourcekitten](https://github.com/jpsim/SourceKitten). It must be installed. Follow the instructions on github page to install 

Needs the sourcekitten framework to convert your project's swift code to AST (Abstract Syntax Tree) and extract strings translated using the localizedWith translation function.

## Compile

Download all swift files in hte same directory and compile

```ruby
swiftc *.swift -o <name_of_the_executable>
```

You can use precompiled executable 'byvLocalizableStringsGenerator'

## Usage

1. Localize project using [ByvLocalizations](https://github.com/byvapps/ByvLocalizations) and it's extensions
2. Copy generated executable in a folder inside project root, (e.g. `/generator/byvLocalizableStringsGenerator`)
3. Open terminal in executable folder and execute `./byvLocalizableStringsGenerator`


## Generated Files

all.strings file with all translations and a file with new translations in all languages of your project (e.g. all.strings, Base.string, en.string)

## Add to your project or update strings

1. Copy the generated en.strings to the 'en.lproj' folder
2. Rename 'Base.strings' to 'Localizable.strings' (If file exist add Base.strings new lines to your previous file)
3. Repeat 5 and 6 for every language folder (e.g. 'es.lproj')
4. Translate
5. Add all Localizable.strings files to your "Copy bundle resources" under build phases
6. lean build (Shift + Cmd + K) and run (Cmd + R)


USE AT OWN RISK