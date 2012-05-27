module ::Gistflow
  VERSION = (`git describe --always`.strip rescue nil) || 'undefined'
end