# The contents of this file are subject to the terms
# of the Common Development and Distribution License
# (the License). You may not use this file except in
# compliance with the License.
#
# You can obtain a copy of the License at
# https://opensso.dev.java.net/public/CDDLv1.0.html or
# opensso/legal/CDDLv1.0.txt
# See the License for the specific language governing
# permission and limitations under the License.
#
# When distributing Covered Code, include this CDDL
# Header Notice in each file and include the License file
# at opensso/legal/CDDLv1.0.txt.
# If applicable, add the following below the CDDL Header,
# with the fields enclosed by brackets [] replaced by
# your own identifying information:
# "Portions Copyrighted [year] [name of copyright owner]"
#
# $Id: xml_sec.rb,v 1.6 2007/10/24 00:28:41 todddd Exp $
#
# Copyright 2007 Sun Microsystems Inc. All Rights Reserved
# Portions Copyrighted 2007 Todd W Saxton.

require 'rubygems'
require "rexml/document"
require "rexml/xpath"
require "openssl"
require "xmlcanonicalizer"
require "digest/sha1"
require "onelogin/saml/validation_error"

module XMLSecurity

  class SignedDocumentNoNs < REXML::Document
    DSIG = "http://www.w3.org/2000/09/xmldsig#"

    attr_accessor :signed_element_id
    attr_accessor :skip_digest_validation
    attr_accessor :last_error

    def initialize(response, options={})
      super(response)
      extract_signed_element_id
      self.skip_digest_validation = options[:skip_digest_validation]
      self.last_error = nil
    end

    def validate(idp_cert_fingerprint, soft = true)
      true
    end
    
    private
    
    def extract_signed_element_id
      reference_element       = REXML::XPath.first(self, "//Signature/SignedInfo/Reference") #, {"ds"=>DSIG})
      self.signed_element_id  = reference_element.attribute("URI").value unless reference_element.nil?
    end
  end
end
