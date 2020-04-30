(define-resource person ()
  :class (s-prefix "foaf:Person")
  :resource-base (s-url "http://luisterpunt.be/id/person/")
  :properties `((:voornaam :string ,(s-prefix "foaf:givenName"))
                (:achternaam :string ,(s-prefix "foaf:familyName"))
                (:birthDate :date ,(s-prefix "schema:birthDate"))
                (:created :datetime ,(s-prefix "dcterms:created"))
                (:modified :datetime ,(s-prefix "dcterms:modified"))
                )
  :has-one `((gender :via ,(s-prefix "schema:gender")
                     :as "gender"))
  :has-many `((account :via ,(s-prefix "foaf:account")
                       :as "account")
              (membership :via ,(s-prefix "schema:member") ;; contact-gegevens zitten op membership, want die zijn vaak specifiek aan de rol (bv verschillend als werknemer vs lezer/lid)
                          :inverse t
                          :as "memberships")
             )
  :on-path "persons"
  )

(define-resource account ()
  :class (s-prefix "foaf:OnlineAccount")
  :resource-base (s-url "http://luisterpunt.be/id/account/")
  :properties `((:provider :url ,(s-prefix "foaf:accountServiceHomepage"))
                (:identifier :string ,(s-prefix "dct:identifier"))
                (:account-name :string ,(s-prefix "foaf:accountName"))
                (:password :string ,(s-prefix "account:password"))
                (:salt :string ,(s-prefix "account:salt")))
  :has-one `((person :via ,(s-prefix "foaf:account")
                         :inverse t
                         :as "gebruiker"))
  :on-path "accounts"
  )

(define-resource gender ()
  :class (s-prefix "schema:genderType")
  :resource-base (s-url "http://luisterpunt.data.gift/concepts/")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :on-path "genders"
  )

(define-resource organization ()
  :class (s-prefix "schema:Organization")
  :resource-base (s-url "http://luisterpunt.be/id/organization/")
  :properties `((:name  :string ,(s-prefix "schema:name")))
  :has-one `((organization-type :via ,(s-prefix "dcterms:type")
                                :as "type")
             (contact-point :via ,(s-prefix "schema:contactPoint")
                            :as "contact-point")
             )
  :has-many `((membership :via ,(s-prefix "schema:member")
                        :inverse t
                        :as "memberships"))
  :on-path "organizations"
  )


;; membership is een entiteit die tussen een person en een organisatie zit om de eigenschappen van de relatie te capteren: type membership (rol), start, einde van de rol. gebruikers kunnen meerdere rollen binnen een organisatie vervullen.
(define-resource membership ()
  :class (s-prefix "schema:Role")
  :resource-base (s-url "http://luisterpunt.be/id/membership/")
  :properties `((:start-date :datetime ,(s-prefix "schema:startDate"))
                (:end-date :datetime ,(s-prefix "schema:endDate"))
                )
  :has-one `((person :via ,(s-prefix "schema:member")
                  :as "person")
            (organization :via ,(s-prefix "schema:member")
                          :inverse t
                          :as "organization")
            (membership-role :via ,(s-prefix "schema:roleName")
                           :as "role")
            (membership-status :via ,(s-prefix "adms:status")
                               :as "status")
            (contact-point :via ,(s-prefix "schema:contactPoint")
                           :as "contact-point"))
  )

;; status van memberhsip (Te bekijken of dit nog nodig is.)
;; TODO: concepten maken voor actief, inactief.
;;Om gebruikers te deactiveren kan je ook gewoon de account verwijderen of de membership beeindigen bv.
(define-resource membership-status ()
  :class (s-prefix "luisterpuntLoan:MembershipStatus")
  :resource-base (s-url "http://luisterpunt.data.gift/concepts/")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :on-path "membership-statuses"
  )


;; TODO: concepten maken lezer, werknemer, inlezer, auteur, ...
(define-resource membership-role ()
  :class (s-prefix "luisterpuntLoan:MembershipRole")
  :resource-base (s-url "http://luisterpunt.data.gift/concepts/")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :on-path "membership-roles"
  )

(define-resource organization-type ()
  :class (s-prefix "luisterpuntLoan:OrganizationType")
  :resource-base (s-url "http://luisterpunt.data.gift/concepts/")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :on-path "organization-types"
  )

(define-resource contact-point ()
  :class (s-prefix "schema:PostalAddress") ; is subklasse van contact point
  :resource-base (s-url "http://luisterpunt.be/id/postal-address/")
  :properties `((:street-address  :string ,(s-prefix "schema:streetAddress"))
                (:postalcode :string ,(s-prefix "schema:postalCode"))
                (:locality :string ,(s-prefix "schema:addressLocality"))
                (:country :string ,(s-prefix "schema:addressCountry"))
                (:name  :string ,(s-prefix "schema:name"))
                (:telephone :string ,(s-prefix "schema:telephone"))
                (:email :string ,(s-prefix "schema:email"))
                (:url :string ,(s-prefix "schema:url"))) ; enkel relevant voor organisaties
  :on-path "contact-points"
  )
