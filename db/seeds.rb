farallon = State.create_with(name: "Farallon").find_or_create_by!(code: "FA")
virginia = State.create_with(name: "Virginia").find_or_create_by!(code: "VA")

fa_acc   = farallon.accounts.create_with(website: 'http://oss.gov').find_or_create_by!(name: 'Office of Secretary of State')
va_acc   = virginia.accounts.create_with(website: 'http://doe.gov').find_or_create_by!(name: 'Department of Elections')

va_admin = va_acc.users.create_with({
  first_name:  'Atest',
  last_name:   'User',
  email:       'usera@sbe.virginia.gov',
  admin:       true,
  password:    'p',
  password_confirmation: 'p'
}).find_or_create_by!(login: 'usera')
va_admin.password = va_admin.password_confirmation = 'usera'
va_admin.save!

va_user = va_acc.users.create_with({
  first_name:  'Btest',
  last_name:   'User',
  email:       'userb@sbe.virginia.gov',
  admin:       false,
  password:    'p',
  password_confirmation: 'p'
}).find_or_create_by!(login: 'userb@sbe.virginia.gov')
va_user.password = va_user.password_confirmation = 'userb'
va_user.save!

fa_admin = fa_acc.users.create_with({
  first_name:  'Jane',
  last_name:   'Jones',
  email:       'jjones@sos.farallon.gov',
  admin:       true,
  password:    'p',
  password_confirmation: 'p'
}).find_or_create_by!(login: 'jjones')
fa_admin.password = fa_admin.password_confirmation = 'jjones'
fa_admin.save!

fa_user = fa_acc.users.create_with({
  first_name:  'Sam',
  last_name:   'Smith',
  email:       'ssmith@sos.farallon.gov',
  admin:       false,
  password:    'p',
  password_confirmation: 'p'
}).find_or_create_by!(login: 'ssmith@sos.farallon.gov')
fa_user.password = fa_user.password_confirmation = 'ssmith'
fa_user.save!
