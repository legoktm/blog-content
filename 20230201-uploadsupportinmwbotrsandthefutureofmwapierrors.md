Title: Upload support in mwbot-rs and the future of mwapi_errors
Date: 2023-02-02 02:00:00
Category: MediaWiki
Tags: mediawiki, mwbot-rs, mwapi_errors, rust

I landed file upload support in the `mwapi` ([docs](https://docs.rs/mwapi/0.5.0-alpha.2/mwapi/index.html)) and `mwbot` ([docs](https://docs.rs/mwbot/0.5.0-alpha.2/mwbot/index.html)) crates yesterday. Uploading files in MediaWiki is kind of complicated, there are multiple state machines to
implement and there are multiple ways to upload files and different options that come with that.

The `mwapi` crate contains [most of the upload logic](https://gitlab.wikimedia.org/repos/mwbot-rs/mwbot/-/blob/e126cdc1fa69f52bfd7918365e781d3a0eb7d264/mwapi/src/upload/mod.rs) but it offers a very simple interface for uploading:

	:::rust
	pub async fn upload<P: Into<Params>>(
	        &self,
	        filename: &str,
	        path: PathBuf,
	        chunk_size: usize,
	        ignore_warnings: bool,
	        params: P,
	) -> Result<String>

This fits with the rest of the `mwapi` style of simple functions that try to provide the user with maximum flexibility.

On the other hand, `mwbot` has a full typed builder with reasonable defaults, I'll just [link to the documentation](https://docs.rs/mwbot/0.5.0-alpha.2/mwbot/upload/struct.UploadRequest.html) instead of copying it all.

A decent amount of internal refactoring was required to make things that took key-value parameters now accept key-value parameters plus bytes that should be uploaded as `multipart/form-data`. Currently only uploading
from a path on disk is supported, in the future I think we should be able to make it more generic and upload from anything that implements `AsyncRead`.

## Next steps for mwapi

This is the last set of functionality that I had on my initial list for `mwapi`, after the upload code gets some real world usage, I'm feeling comfortable calling it complete enough for a 1.0 stable release. There
is still probably plenty of work to be done (like `rest.php` support maybe?), but from what I percieve a "low-level" MediaWiki API library should do, I think it's checked the boxes.

Except....

## Future of mwapi_errors

It took me a while to get comfortable with error handling in Rust. There are a lot of different errors the MediaWiki API can raise, and they all can happen at the same time or different times! For example, editing a page could
fail because of some HTTP-level error, you could be blocked, your edit might have tripped the spam filter, you got an edit conflict, etc. Some errors might be common to any request, some might be specific to a page or the
text you're editing, and others might be temporary and totally safe to retry.

So I created one massive error type and the `mwapi_errors` crate was born, mapping all the various API error codes to the correct Rust type. The `mwapi`, `parsoid`, and `mwbot` crates all use the same `mwapi_error::Error` type
as their error type, which is super convenient, usually. 

The problem comes that they all need to use the exact same version of `mwapi_errors`, otherwise the Error type will be different and cause super confusing compilation errors. So if we need to make a breaking change to any
error type, all 4 crates need to issue semver-breaking releases, even if they didn't use that functionality!

Before `mwapi` can get a 1.0 stable release, `mwapi_errors` would need to be stable too. But I am leaning in the direction of splitting up the errors crate and just giving each crate its own `Error` type, just like all the
other crates out there do. And we'll use `Into` and `From` to convert around as needed.
