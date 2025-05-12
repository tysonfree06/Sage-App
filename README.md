# Sage: The Fastest Relationship Problem Solver

## 🧠 Introduction
Sage is a relationship tool designed to help couples discover personalized, AI-generated date and gift ideas. Users can connect with their partner, personalize their preferences, save and share ideas, and engage in a reward system with monthly raffles.

---

## 🛠️ Tech Stack / Languages Used
- **Frontend:** React (Web PWA)
- **Backend:** Firebase Cloud Functions
- **Database:** Firestore
- **Authentication:** Firebase Auth
- **Deployment:** Firebase Hosting (PWA)
- **Version Control:** Git, GitHub

---

## 🔌 APIs Used
- **OpenAI API (GPT-4o Mini):** Personalized idea generation
- **Stripe API:** Subscription and payment processing
- **Tango Card API:** Raffle reward fulfillment with gift cards
- **Mailchimp API:** Email automations (sign up, reset password, marketing)
- **Firebase Cloud Messaging (optional):** Push notifications
- **Google Analytics / Firebase Analytics:** Event tracking and user behavior

---

## 📈 Monitoring and Tracking
- **Performance & Errors:** Firebase Performance Monitoring, Crashlytics
- **User Behavior & Analytics:** Google Analytics, Firebase Analytics
- **Error Handling:** Cloud Function logs (Firebase Console > Functions > Logs)
- **Raffle & Points Tracking:** Firestore collections with audit timestamps
- **Feedback & Bug Reports:** Stored in Firestore under `feedback` collection

---
### 🧱 File Structure Explanation
Provide a list or tree view of the key folders and files:
```bash
/src
  /components
  /pages
  /utils
  /config
```

---
## 🚀 Getting Started

```bash
git clone https://github.com/your-org/sage-app.git
cd sage-app
npm install
npm run dev
```

Environment variables should be stored in a `.env` file (not committed to Git):
```
FIREBASE_API_KEY=
OPENAI_API_KEY=
STRIPE_SECRET_KEY=
MAILCHIMP_API_KEY=
TANGO_CARD_CREDENTIALS=
```

---

## 🤝 Contributing to Sage

We use a simplified **Gitflow strategy** to keep our codebase clean, reviewable, and production-ready. We also keep code organized by leaving comments and documentation.

### 🧠 Code Guidelines

#### 🔧 Global Config
- Store global variables (e.g., colors, fonts, constants) in separate config files.
- Use shared theme files for design tokens such as colors, font sizes, spacing.

#### 💬 Comments
- **Consistent Documentation**: Use clear and concise comments to explain the purpose of each component, function, or block of logic.
- **Function Headers**: Every function should have a comment block including:
  - Description
  - Parameters
  - Return value
 - **Inline Comments**: Add inline comments where logic is not self-explanatory or involves edge cases.

 ##### Example
```js
/**
 * Calculates total raffle points.
 * @param {number} actions - Number of qualifying actions
 * @returns {number} Total points
 */
function calculatePoints(actions) {
  return actions * 100;
}
```
---

---

### 🧠 Key Branches
- `main`: Production-ready code  
- `dev`: Active development branch  
- `feature/<name>`: One branch per feature (e.g. `feature/partner-connection`)  
- `bugfix/<name>`: For fixing bugs (e.g. `bugfix/login-error`)  
- `hotfix/<name>`: For urgent fixes directly from `main` (e.g. `hotfix/payment-crash`)  

---

### 🛠️ 1. Creating a New Feature

> For building new app features or enhancements

#### 🔁 Flow:
1. Fork `main` into `dev`
2. Create a `feature/*` branch off `dev`
3. Push code changes
4. Submit PR from `feature/*` → `dev`
5. Once tested and approved, merge `dev` → `main`

#### 💻 Commands:
```bash
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name

# Make your changes
git add .
git commit -m "Add [feature name]"

git push origin feature/your-feature-name

# After PR approval:
git checkout dev
git merge feature/your-feature-name
git push origin dev

git checkout main
git merge dev
git push origin main
```

---

### 🐛 2. Bug Fixes

> For fixing small or non-critical bugs

#### 🔁 Flow:
- Create a `bugfix/*` branch off `dev`
- Follow the same merge pattern as a feature

#### 💻 Commands:
```bash
git checkout dev
git pull origin dev
git checkout -b bugfix/login-error

# Fix the bug
git add .
git commit -m "Fix login error on mobile"

git push origin bugfix/login-error
```

---

### 🚨 3. Hotfixes (Production Issues)

> For urgent fixes to the live/production app

#### 🔁 Flow:
- Create a `hotfix/*` branch off `main`
- Merge back into both `main` and `dev`

#### 💻 Commands:
```bash
git checkout main
git pull origin main
git checkout -b hotfix/payment-crash

# Fix the issue
git add .
git commit -m "Hotfix: payment crash on checkout"

git push origin hotfix/payment-crash

# Merge into main and dev
git checkout main
git merge hotfix/payment-crash
git push origin main

git checkout dev
git merge hotfix/payment-crash
git push origin dev
```

---

### 🏷️ Tagging Stable Versions (ONLY DO ONCE A NEW STABLE VERSION IS IN MAIN)

Use Git tags to mark stable versions of the codebase so you can easily roll back or reference previous builds.

#### Version Number Convention

MAJOR.MINOR.PATCH

#### Breakdown:
- **MAJOR**: Breaking changes (e.g., redesigns, removed features)
- **MINOR**: Backward-compatible features or enhancements
- **PATCH**: Bug fixes and small improvements

#### Example Versions

- `v1.0.0`: Initial stable release
- `v1.1.0`: Added new features like referral system
- `v1.1.1`: Fixed a bug in referral link tracking
- `v2.0.0`: Major overhaul or breaking changes

#### How to Tag a Version:
```bash
git tag v1.0.0
git push origin v1.0.0
```

#### View All Tags:
```bash
git tag
```

#### Checkout a Specific Tag (read-only):
```bash
git checkout v1.0.0
```

#### Create a New Branch From a Tag:
```bash
git checkout -b hotfix/v1.0.0-patch v1.0.0
```

---


## 📬 Contact
For questions or contributions, reach out at [your-email@example.com] or open an issue on GitHub.
  
