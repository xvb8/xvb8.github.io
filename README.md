# xvb8.github.io

Static tools hosted on GitHub Pages.

## Cloud Backend

This site now expects Supabase for both authentication and data storage.

Why this architecture:
- The repo is public, so secrets cannot live in client-side JavaScript.
- Supabase anon keys are safe to expose publicly when Row Level Security is configured correctly.
- Real access control must be enforced server-side by database policies, not by browser cookies.

### Required Setup

1. Create a Supabase project.
2. In the Supabase SQL editor, run [supabase-schema.sql](supabase-schema.sql).
3. In Supabase Auth, create the user account that should own the data.
4. Open [cloud-config.js](cloud-config.js) and set:
	- `supabaseUrl`
	- `supabaseAnonKey`
5. Deploy the updated files to GitHub Pages.

### Important Security Note

Allowed in the public repo:
- Supabase project URL
- Supabase anon/public key

Never put this in the repo:
- Supabase service-role key
- Any database password
- Any private admin token

### App Behavior

- [qa-manager.html](qa-manager.html) now signs in with Supabase Auth and stores Q&A data in the `qa_items` table.
- [timer-queue.html](timer-queue.html) now signs in with Supabase Auth and stores queue data in the `timer_items` and `timer_state` tables.
- The Q&A app will import any existing browser-local Q&A data into the cloud the first time an authenticated account opens an empty cloud library.

### Current Limitation

Authentication currently uses browser prompts for email and password entry to keep the change small and compatible with the static site. The next sensible step is replacing that with a proper sign-in modal.