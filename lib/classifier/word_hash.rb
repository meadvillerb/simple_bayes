# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

# These are extensions to the String class to provide convenience
# methods for the Classifier package.
# 
# This class wraps Hash instead of adding methods to String, to avoid
# extending the core class too much.

require 'fast_stemmer'

module Classifier
  
  class WordHash < Hash
    
    # Create a hash of strings => ints. Each word in the string is stemmed
    # and indexed to its frequency in the document.
    #
    # clean_source (bool):
    #   Return a word hash without extra punctuation or short symbols,
    #   just stemmed words
    def initialize( source, clean_source=true )
      super()
    
      populate_with( clean_source ?
        source.gsub(/[^\w\s]/,"").split :
        source.gsub(/[^\w\s]/,"").split + source.gsub(/[\w]/," ").split
      )
    end
  
  
    private
  
    def populate_with( words )
      words.each do |word|
        word.downcase! if word =~ /[\w]+/
        if valid?( word )
          key = word.stem
          self[key] ||= 0
          self[key] += 1
        end
      end
    end
  
    # Removes common punctuation symbols, returning a new string.
    # E.g.,
    #   "Hello (greeting's), with {braces} < >...?".without_punctuation
    #   => "Hello  greetings   with  braces         "
    def strip_punctuation( s )
      s.tr( ',?.!;:"@#$%^&*()_=+[]{}\|<>/`~', " " ).tr( "'\-", "")
    end
  
    # Test if the string contains letters AND numbers.
    def mixed_alphanumeric?( s )
      !!((s =~ /^[A-z]/ && s.index(/[0-9]/)) || (s =~ /^\d/ && s.index(/[A-z]/)))
    end
  
    def valid?( s )
      s =~ /[^\w]/ ||
      ! CORPUS_SKIP_WORDS.include?(s) &&
      s.length > 2 &&
      ! mixed_alphanumeric?(s)
    end
  
    CORPUS_SKIP_WORDS = [
        "a",
        "again",
        "all",
        "along",
        "are",
        "also",
        "an",
        "and",
        "as",
        "at",
        "but",
        "by",
        "came",
        "can",
        "cant",
        "couldnt",
        "did",
        "didn",
        "didnt",
        "do",
        "doesnt",
        "dont",
        "ever",
        "first",
        "from",
        "have",
        "her",
        "here",
        "him",
        "how",
        "i",
        "if",
        "in",
        "into",
        "is",
        "isnt",
        "it",
        "itll",
        "just",
        "last",
        "least",
        "like",
        "most",
        "my",
        "new",
        "no",
        "not",
        "now",
        "of",
        "on",
        "or",
        "should",
        "sinc",
        "so",
        "some",
        "th",
        "than",
        "this",
        "that",
        "the",
        "their",
        "then",
        "those",
        "to",
        "told",
        "too",
        "true",
        "try",
        "until",
        "url",
        "us",
        "were",
        "when",
        "whether",
        "while",
        "with",
        "within",
        "yes",
        "you",
        "youll"
      ]
  end
  
end