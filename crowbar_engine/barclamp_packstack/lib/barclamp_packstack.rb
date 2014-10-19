require "barclamp_packstack/engine"

module BarclampPackstack

  TABLE_PREFIX = "bc_packstack_"

  def self.table_name_prefix
    TABLE_PREFIX
  end

  # GREG: Is this still needed!!??!!
  def self.genkey
    # This will wind up becoming a randomly-chosen AES128 key.
    randbits = IO.read("/dev/urandom",16)
    t = Time.now
    header = [1,               # ???
              t.to_i,          # Seconds since epoch,
              t.nsec,          # Nanoseconds part of create time.
              randbits.length  # In case we want a longer key
             ]
    # Return our properly packed encoded header + the key.
    # This returns a Base64 encoded string.
    [header.pack('vVVv')+randbits].pack("m").strip
  end

end
