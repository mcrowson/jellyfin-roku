function api_BrandingConfig() as object
  ' Gets branding configuration
  ' {
  '  LoginDisclaimer: string
  '  CustomCss: string
  ' }
  resp = APIRequest("Branding/Configuration")
  return getJson(resp)
end function
