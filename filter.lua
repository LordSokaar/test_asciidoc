function strip_meta(meta)
    meta.subtitle = nil
    meta.author = nil
    meta.date = nil
    return meta
  end
  
  return {{Meta = strip_meta}}