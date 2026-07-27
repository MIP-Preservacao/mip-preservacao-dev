// MIP Preservação Industrial S11D — Service Worker
// Versão: 2.0.0 — altere este número para forçar atualização em todos os dispositivos
var CACHE = 'mip-s11d-v2.1.0';

// Arquivos a cachear na instalação
var ARQUIVOS = [
  './',
  './mip_preservacao_s11d_v1.0.0.html'
];

// Instalar: cachear o app
self.addEventListener('install', function(e){
  console.log('[SW] Instalando v2.1.0');
  e.waitUntil(
    caches.open(CACHE).then(function(cache){
      return cache.addAll(ARQUIVOS).catch(function(err){
        console.warn('[SW] Erro ao cachear:', err);
      });
    }).then(function(){
      return self.skipWaiting();
    })
  );
});

// Ativar: limpar caches antigos
self.addEventListener('activate', function(e){
  console.log('[SW] Ativando, limpando caches antigos');
  e.waitUntil(
    caches.keys().then(function(keys){
      return Promise.all(
        keys.filter(function(k){ return k !== CACHE; })
            .map(function(k){
              console.log('[SW] Deletando cache antigo:', k);
              return caches.delete(k);
            })
      );
    }).then(function(){
      return self.clients.claim();
    })
  );
});

// Fetch: network-first (tenta rede, cai no cache se offline)
self.addEventListener('fetch', function(e){
  // Ignorar requisições externas (Supabase, CDNs)
  if(!e.request.url.startsWith(self.location.origin)) return;
  // Ignorar métodos não-GET
  if(e.request.method !== 'GET') return;

  e.respondWith(
    fetch(e.request)
      .then(function(response){
        // Resposta válida — atualizar cache
        if(response && response.status === 200){
          var clone = response.clone();
          caches.open(CACHE).then(function(cache){
            cache.put(e.request, clone);
          });
        }
        return response;
      })
      .catch(function(){
        // Offline — servir do cache
        return caches.match(e.request).then(function(cached){
          if(cached) return cached;
          // Fallback: página principal
          return caches.match('./mip_preservacao_s11d_v1.0.0.html');
        });
      })
  );
});
