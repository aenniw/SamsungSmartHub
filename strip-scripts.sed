1 {
  /^#!/ {
    p
  }
}

/^[\t\ ]*#/d

/\.*#.*/ {
  /[\x22\x27].*#.*[\x22\x27]/ !{
    :regular_loop
      s/\(.*\)*[^\$]#.*/\1/
    t regular_loop
  }
  /[\x22\x27].*#.*[\x22\x27]/ {
    :special_loop
      s/\([\x22\x27].*#.*[^\x22\x27]\)#.*/\1/
    t special_loop
  }
  /\\#/ {
    :second_special_loop
      s/\(.*\\#.*[^\]\)#.*/\1/
    t second_special_loop
  }
  /$#/ {
    :third_special_loop
      s/\(.*$#.*[^$\]\)#.*/\1/
    t third_special_loop
  }
}