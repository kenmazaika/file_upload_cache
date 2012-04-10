File-Upload-Cache
-----------------

This is a rails engine that provides a simple method for restoring file uploads from the server after a validation error.  Typically users are required to reupload the same file to the server between posts if there is a validation error on a different field.

Stack
-----

This tool is designed to provide components that work with the full stack, to provide this functionality in the simplest way for a user.

Requirements:

 * Rails 3+

Additional Hooks (these will optionally add functionality out of the box, but these components are not required to use the other functionality)

 * Formtastic (new input added for cached file uploads)
 * CarrierWave (works with CarrierWave uploads to cache them)

File-Upload-Cache works like CarrierWave's Cache
----------------------

 * Make uploads work across redisplays
 * Leverages hidden fields on the forms, to prevent reuploading the same binary data multiple times
 * Allow a user to remove an asset

 Implementation Differences From CarrierWave Cache
 -------------------------------------------------

  * Stores the cached file data in a cache instead of directly on the filesystem.  By default it uses Rails.cache, but this can be configured to use any class that implements `write(key, value)` and `read(key)`.  This means that unlike the CarrierWave solution:
    * This will work on systems that are load balanced so long as they share the same cache
    * Can be easily configured to use different stores instead of just the file system (redis, memcache, etc)
    * Cached assets are served through the rails environment as dynamic content, instead of static content that can be served directly by Rack or a server like Apache or Nginx.
  * Built in integration with the full stack.  Formtastic integration & Javascript for dealing with the cached value 

Instructions
------------

Add to Gemfile

```
gem 'file_upload_cache'
```

Add integration to the model.  For example, a field called avatar the following could be used to add caching on an existing image field.

```
  cached_file_for :avatar
  attr_accessible :avatar, :avatar_cache_id
```

Change formtastic input to use the uploader input, provided by this engine

```
f.input :avatar, :as => :uploader
```

Add the following javascript to the pages that have the input in it:

```
  window.file_upload_cache = window.file_upload_cache || {};
  window.file_upload_cache.initialize = function() {

    $.each($('.cached_file'), function(index, element) {
      var id = '#' + element.id,
      $id = $(id),
      $cache = $(id + "_cache"),
      $replace = $(id + '_replace'),
      $existing = $(id + "_existing");

      if($cache.val()){
        $(id).hide();
      }
      $($replace).click(function() {
        $($id).show();
        $($existing).hide();
        $($cache).val(null);
      });
    });
  }

  $(function() {
    window.file_upload_cache.initialize();
  });
```
