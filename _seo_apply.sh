#!/usr/bin/env bash
# One-shot SEO injector. Updates title, meta description, canonical, OG, Twitter,
# and JSON-LD on every page. Safe to re-run.
set -e
cd "$(dirname "$0")"

BASE='https://reachedbyte.github.io/lewes-chiropractic-clinic'
OG="$BASE/assets/og-image.jpg"

# Common LocalBusiness JSON-LD (goes on every page)
read -r -d '' LOCAL_LD <<'JSON' || true
<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":["LocalBusiness","MedicalBusiness"],
  "@id":"https://reachedbyte.github.io/lewes-chiropractic-clinic/#clinic",
  "name":"Lewes Chiropractic Clinic",
  "alternateName":"Lewes Chiropractic",
  "url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/",
  "logo":"https://reachedbyte.github.io/lewes-chiropractic-clinic/assets/favicon.png",
  "image":"https://reachedbyte.github.io/lewes-chiropractic-clinic/assets/og-image.jpg",
  "telephone":"+44-1273-483327",
  "email":"info@leweschiropracticclinic.co.uk",
  "priceRange":"££",
  "foundingDate":"1990",
  "address":{"@type":"PostalAddress","streetAddress":"16 West Street","addressLocality":"Lewes","addressRegion":"East Sussex","postalCode":"BN7 2NZ","addressCountry":"GB"},
  "geo":{"@type":"GeoCoordinates","latitude":50.873,"longitude":0.010},
  "openingHoursSpecification":[{"@type":"OpeningHoursSpecification","dayOfWeek":["Monday","Tuesday","Wednesday","Thursday","Friday"],"opens":"08:00","closes":"18:00"},{"@type":"OpeningHoursSpecification","dayOfWeek":"Saturday","opens":"09:00","closes":"13:00"}],
  "areaServed":[{"@type":"City","name":"Lewes"},{"@type":"City","name":"Brighton"},{"@type":"City","name":"Eastbourne"},{"@type":"City","name":"Hastings"},{"@type":"City","name":"Ringmer"},{"@type":"AdministrativeArea","name":"East Sussex"},{"@type":"Country","name":"United Kingdom"}],
  "medicalSpecialty":"Chiropractic",
  "availableService":[
    {"@type":"MedicalProcedure","name":"Back Pain Treatment","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/back-pain.html"},
    {"@type":"MedicalProcedure","name":"Neck Pain Treatment","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/neck-pain.html"},
    {"@type":"MedicalProcedure","name":"Headache & Migraine Care","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/headaches-migraine.html"},
    {"@type":"MedicalProcedure","name":"Hip & Knee Care","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/hip-knees.html"},
    {"@type":"MedicalProcedure","name":"Shoulder & Elbow Care","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/shoulder-elbow.html"},
    {"@type":"MedicalProcedure","name":"Sports Injury Chiropractic","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/sports-injuries.html"},
    {"@type":"MedicalProcedure","name":"Pregnancy Chiropractic","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/pregnancy.html"},
    {"@type":"MedicalProcedure","name":"Posture & Desk Strain Care","url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/posture-desk-strain.html"}
  ],
  "founder":{"@type":"Person","name":"Helle Henriksen","jobTitle":"Doctor of Chiropractic, Certified Chiropractic Sports Physician","alumniOf":"Anglo-European College of Chiropractic"},
  "aggregateRating":{"@type":"AggregateRating","ratingValue":"4.9","reviewCount":"42","bestRating":"5","worstRating":"1"},
  "sameAs":["https://reachedbyte.github.io/lewes-chiropractic-clinic/"]
}
</script>
<script type="application/ld+json">
{
  "@context":"https://schema.org",
  "@type":"WebSite",
  "@id":"https://reachedbyte.github.io/lewes-chiropractic-clinic/#website",
  "url":"https://reachedbyte.github.io/lewes-chiropractic-clinic/",
  "name":"Lewes Chiropractic Clinic",
  "publisher":{"@id":"https://reachedbyte.github.io/lewes-chiropractic-clinic/#clinic"},
  "potentialAction":{"@type":"SearchAction","target":"https://reachedbyte.github.io/lewes-chiropractic-clinic/?s={search_term_string}","query-input":"required name=search_term_string"}
}
</script>
JSON

# Per-page SEO data: slug | TITLE | DESCRIPTION | KEYWORDS
read_pages() {
cat <<'DATA'
index.html|Chiropractor in Lewes — Lewes Chiropractic Clinic | Back, Neck & Sports Injury Care Since 1990|Trusted chiropractor in Lewes, East Sussex since 1990. Expert care for back pain, neck pain, headaches and sports injuries. GCC-registered. Same-week appointments at 16 West Street, Lewes BN7 2NZ. Call 01273 483327.|chiropractor lewes, chiropractic clinic lewes, back pain lewes, neck pain lewes, sports chiropractor lewes, chiropractor east sussex, helle henriksen chiropractor
about.html|About Helle Henriksen DC, CCSP — Lewes Chiropractor | Lewes Chiropractic Clinic|Meet Helle Henriksen DC, CCSP — registered chiropractor in Lewes since 1992. Postgraduate-certified in sports chiropractic. Pregnancy, postnatal and paediatric care.|helle henriksen chiropractor, lewes chiropractor, chiropractic clinic lewes, sports chiropractor east sussex, ccsp chiropractor uk
conditions.html|Conditions Treated — Chiropractor Lewes | Back, Neck, Headaches, Sports Injuries|Chiropractic care in Lewes for back pain, neck pain, headaches & migraine, hip & knee, shoulder & elbow, sports injuries, pregnancy and posture strain. Book today.|chiropractor lewes conditions, back pain treatment lewes, neck pain treatment lewes, headache chiropractor lewes, sports injury chiropractor lewes
treatments.html|Chiropractic Treatments in Lewes | Adjustment, Acupuncture, Soft-Tissue, Rehab|Hands-on chiropractic care, acupuncture, soft-tissue work and movement guidance at Lewes Chiropractic Clinic. Considered, evidence-informed treatment in central Lewes.|chiropractic treatment lewes, chiropractor lewes adjustment, acupuncture lewes, soft tissue therapy lewes, sports rehab lewes
fees.html|Chiropractic Fees in Lewes | Initial £75 · Follow-up £48 — Lewes Chiropractic Clinic|Honest, transparent chiropractic pricing in Lewes. Initial consultation £75 (45 min), follow-up £48 (20-30 min). No padded plans, no commitments. GCC-registered.|chiropractor fees lewes, chiropractic prices lewes, chiropractic cost east sussex, lewes chiropractic clinic prices
visit.html|Visit Lewes Chiropractic Clinic | 16 West Street, Lewes BN7 2NZ — Map & Directions|Find Lewes Chiropractic Clinic at 16 West Street, Lewes, East Sussex BN7 2NZ. Three minutes from Lewes station. Easy parking. Map, directions and getting-here details.|chiropractor lewes location, 16 west street lewes, lewes chiropractic clinic directions, chiropractor near me lewes, chiropractor near lewes station
book.html|Book a Chiropractic Appointment in Lewes | Same-week Visits — Lewes Chiropractic|Book your chiropractic appointment in Lewes. Same-week appointments usually available. Call 01273 483327 or send a quick enquiry online — no GP referral needed.|book chiropractor lewes, chiropractic appointment lewes, same week chiropractor lewes, chiropractor near me booking, lewes chiropractor enquiry
back-pain.html|Back Pain Chiropractor in Lewes | Lower Back Pain Treatment — Lewes Chiropractic|Expert back pain chiropractor in Lewes, East Sussex. Care for lower back pain, sciatica, postural strain and movement restriction. GCC-registered, since 1990.|back pain chiropractor lewes, lower back pain treatment lewes, sciatica chiropractor lewes, slipped disc lewes, back pain east sussex
neck-pain.html|Neck Pain Chiropractor in Lewes | Tension, Stiffness & Whiplash Care — Lewes Chiropractic|Professional neck pain chiropractor in Lewes — care for neck tension, stiffness, headaches from the neck and whiplash. Same-week appointments. Call 01273 483327.|neck pain chiropractor lewes, neck stiffness treatment lewes, whiplash chiropractor east sussex, tech neck lewes, neck pain east sussex
headaches-migraine.html|Headaches & Migraine Chiropractor in Lewes | Cervicogenic & Tension Headache Care|Chiropractic care in Lewes for headaches and migraine — including cervicogenic, tension and posture-related headaches. GCC-registered. Same-week appointments.|headache chiropractor lewes, migraine chiropractor lewes, cervicogenic headache treatment, tension headache lewes, chiropractor for headaches east sussex
hip-knees.html|Hip & Knee Pain Chiropractor in Lewes | Joint & Movement Care — Lewes Chiropractic|Chiropractic care in Lewes for hip and knee pain — discomfort affecting walking, stairs and activity. Whole-chain assessment, not just the painful spot.|hip pain chiropractor lewes, knee pain chiropractor lewes, joint pain treatment lewes, hip stiffness east sussex, runners knee lewes
shoulder-elbow.html|Shoulder & Elbow Chiropractor in Lewes | Frozen Shoulder, Tennis Elbow & Rotator Cuff|Chiropractic care in Lewes for shoulder and elbow problems — frozen shoulder, rotator cuff strain, tennis & golfer's elbow. GCC-registered, since 1990.|shoulder pain chiropractor lewes, frozen shoulder treatment lewes, tennis elbow chiropractor, rotator cuff lewes, elbow pain east sussex
sports-injuries.html|Sports Injury Chiropractor in Lewes | CCSP-Certified Sports Chiropractic|Sports injury chiropractor in Lewes, East Sussex — CCSP-certified care for runners, cyclists, gym & weekend athletes. Return-to-sport rehab and injury prevention.|sports chiropractor lewes, sports injury treatment lewes, ccsp chiropractor uk, runners injury lewes, cycling injury chiropractor east sussex
pregnancy.html|Pregnancy Chiropractor in Lewes | Gentle Pre & Postnatal Care — Lewes Chiropractic|Gentle pregnancy chiropractor in Lewes — supportive care for low back, pelvic and hip discomfort. Techniques suited to each trimester and the postnatal period.|pregnancy chiropractor lewes, prenatal chiropractor east sussex, postnatal chiropractor lewes, pelvic pain pregnancy lewes, gentle chiropractor lewes
posture-desk-strain.html|Desk & Posture Chiropractor in Lewes | Tech Neck, Sitting Strain Care — Lewes Chiropractic|Chiropractic care in Lewes for desk and posture strain — neck, upper-back, jaw and shoulder strain from long hours at the screen. Workstation advice included.|posture chiropractor lewes, desk strain treatment lewes, tech neck chiropractor, sitting posture lewes, workstation pain east sussex
DATA
}

apply_seo() {
  local slug="$1" title="$2" desc="$3" keywords="$4"
  local url="$BASE/$slug"
  if [ "$slug" = "index.html" ]; then url="$BASE/"; fi

  # 1) Replace <title>
  perl -i -pe "s|<title>[^<]*</title>|<title>${title}</title>|" "$slug"

  # 2) Replace <meta name="description">
  perl -i -pe "s|<meta name=\"description\" content=\"[^\"]*\">|<meta name=\"description\" content=\"${desc}\">|" "$slug"

  # 3) Inject SEO bundle (canonical, keywords, robots, OG, Twitter, JSON-LD) right after the description meta
  # First strip any prior block to keep idempotent
  perl -i -0pe 's|<!-- SEO:START -->.*?<!-- SEO:END -->\n||s' "$slug"

  local seo_block
  seo_block="<!-- SEO:START -->
<link rel=\"canonical\" href=\"${url}\">
<meta name=\"keywords\" content=\"${keywords}\">
<meta name=\"author\" content=\"Lewes Chiropractic Clinic\">
<meta name=\"robots\" content=\"index, follow, max-image-preview:large, max-snippet:-1\">
<meta name=\"geo.region\" content=\"GB-ESX\">
<meta name=\"geo.placename\" content=\"Lewes\">
<meta name=\"geo.position\" content=\"50.873;0.010\">
<meta name=\"ICBM\" content=\"50.873, 0.010\">
<meta property=\"og:type\" content=\"website\">
<meta property=\"og:site_name\" content=\"Lewes Chiropractic Clinic\">
<meta property=\"og:locale\" content=\"en_GB\">
<meta property=\"og:url\" content=\"${url}\">
<meta property=\"og:title\" content=\"${title}\">
<meta property=\"og:description\" content=\"${desc}\">
<meta property=\"og:image\" content=\"${OG}\">
<meta property=\"og:image:width\" content=\"1200\">
<meta property=\"og:image:height\" content=\"630\">
<meta property=\"og:image:alt\" content=\"Lewes Chiropractic Clinic — established 1990\">
<meta name=\"twitter:card\" content=\"summary_large_image\">
<meta name=\"twitter:title\" content=\"${title}\">
<meta name=\"twitter:description\" content=\"${desc}\">
<meta name=\"twitter:image\" content=\"${OG}\">
<meta name=\"format-detection\" content=\"telephone=yes\">
<!-- SEO:END -->"

  # Insert right after the description meta
  perl -i -0pe "s|(<meta name=\"description\" content=\"[^\"]*\">)|\$1\n${seo_block}|" "$slug"
}

# Apply per-page metadata
while IFS='|' read -r slug title desc keywords; do
  [ -z "$slug" ] && continue
  echo "  → $slug"
  apply_seo "$slug" "$title" "$desc" "$keywords"
done < <(read_pages)

# 4) Inject the common LocalBusiness + WebSite JSON-LD before </head> on every page
for f in *.html; do
  # Strip prior block first (idempotent)
  perl -i -0pe 's|<!-- LD:START -->.*?<!-- LD:END -->\n||s' "$f"
  # Build script tag content
  awk -v ld="$LOCAL_LD" 'BEGIN{print "<!-- LD:START -->\n" ld "\n<!-- LD:END -->"}' > /tmp/_ld.html
  # Insert before </head>
  perl -i -pe 'BEGIN{open(F,"</tmp/_ld.html");local $/;$ld=<F>;close F} s|</head>|$ld\n</head>|' "$f"
done

echo "✓ SEO blocks applied to all pages"
