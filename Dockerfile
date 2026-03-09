FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

### প্রতিটা line কী করে:
```
FROM nginx:alpine
↓
Docker Hub থেকে nginx নামের
web server image নেবো
alpine = ছোট size (5MB মাত্র!)

COPY index.html /usr/share/nginx/html/
↓
আমাদের index.html কে
nginx এর web folder এ রাখবো
যেন browser এ দেখা যায়

EXPOSE 80
↓
Port 80 খুলে দেবো
Browser এই port এ connect করবে
```
```
Commit message: "Add Dockerfile"
→ Commit changes
```

---

## 📄 File 3 — Jenkinsfile Update করো
```
GitHub repo → Jenkinsfile → ✏️ edit
সব মুছে এই code দাও:
