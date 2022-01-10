module Proposals
  def custom_fill_in_proposal
    byebug
    fill_in_new_proposal_title with: "Help refugees"
    # fill_in "Proposal summary", with: "In summary, what we want is..."
    # fill_in_ckeditor "Proposal text", with: "This is very important because..."
    # fill_in "External video URL", with: "https://www.youtube.com/watch?v=yPQfcG-eimk"
    # fill_in "Full name of the person submitting the proposal", with: "Isabel Garcia"
    # check "I agree to the Privacy Policy and the Terms and conditions of use"
    fill_in 'Titel des Vorschlages', with: "Titel des Vorschlages"
    fill_in 'Zusammenfassung Vorschlag', with: "Zusammenfassung Vorschlag..."
    fill_in_ckeditor "Vorschlagstext", with: "Vorschlagstext..."
    fill_in "Externes Video URL", with: "https://www.youtube.com/watch?v=_51lRi-YJjk"
    check "Ich stimme der Datenschutzbestimmungen und den Allgemeine Nutzungsbedingungen zu"
  end
end
