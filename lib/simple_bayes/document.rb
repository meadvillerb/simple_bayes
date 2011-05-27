# encoding: utf-8
# Author::		Lucas Carlson	 (mailto:lucas@rufy.com)
#             Ian D. Eccles
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::		LGPL

# Instances of this class essentially basic TermOccurrence implementors that
# do a bit of filtering on a given string of text.  They strip the text of
# all punctuation then downcase and filter the resulting words.  Some
# convenience methods have been added to make instances behave similarly
# to hashes, such as the +[]+ method, as well as being
# Enumerable with the +each+ method calling the internal hash's +each+ method.

module SimpleBayes
	class Document
	  include Enumerable
	  include TermOccurrence
	  
	  attr_reader :term_occurrences
	  
		def initialize text
		  @term_occurrences = Hash.new 0
			populate_with strip_punctuation(text).split
		end
		
		def [] term
		  term_occurrences[term]
	  end
		
		def each &block
		  term_occurrences.each(&block)
	  end
		
		private
		def populate_with(words)
			words.each do |word|
				word.downcase! if word =~ /[\w]+/
				if valid? word
				  store_term word, 1
				end
			end
		end
		
		def strip_punctuation(string)
		  # What about "'" ?  CORPUS_SKIP_WORDS includes contractions sans
		  # the apostrophe, but there doesn't seem to be anything that actually
		  # deals with apostrophes.  I'm really beginning to think this isn't
		  # all that helpful.
			string.tr(',?.!;:"@#$%^&*()_=+[]{}\|<>/`~-', " ")
		end
		
		def valid?(string)
		  # So if the string contains a non-word character or it's not in
		  # the list of skip words, we include it.  But, the string has already
		  # been stripped of its puncuation, which doesn't leave many non-word
		  # characters left.  Further, none of the skip words contain non-word
		  # characters, so if a string does have non-word characters, it is
		  # not included in @skip_words.  Also, with only one set of skip words,
		  # we can just refer to the constant.
			#string =~ /[^\w]/ || !@skip_words.include?(string)
			!CORPUS_SKIP_WORDS.include?(string)
		end

    # I question how necessary these are?
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
				"youll" ]
	end	
end
