'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "76f08d47ff9f5715220992f993002504",
"assets/FontManifest.json": "fabe749aa85ba93a2b92f346b611a78b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "d7d83bd9ee909f8a9b348f56ca7b68c6",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "15d54d142da2f2d6f2e90ed1d55121af",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "262525e2081311609d1fdab966c82bfc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/u_credit_card/assets/images/master_card.png": "fe807bce353d0bc60f09a60409236255",
"assets/packages/u_credit_card/assets/images/nfc.png": "d0e0c4bc69cb7005c10ce684f0603468",
"assets/packages/u_credit_card/assets/images/discover.png": "b66abb29035e7fa885cb565c4aedfb30",
"assets/packages/u_credit_card/assets/images/amex.png": "78a87e922e4af6db197310737ef9b9fe",
"assets/packages/u_credit_card/assets/images/chip.png": "c7c92244ce8c689f6ac515b9569bb09f",
"assets/packages/u_credit_card/assets/images/visa_logo.png": "8ce71663ec640331057e5b42cacc1994",
"assets/packages/u_credit_card/fonts/OCR-A-regular.ttf": "426fbbd15636b132aafe10f83c816e3f",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/translations/en-US.json": "55d5a477301731cb851467a8bf712721",
"assets/assets/translations/vi-VN.json": "32850289ac76b24d32cb39c934ff26bc",
"assets/assets/images/persion_languege.svg": "5b8a8f36821c65512b4294e9d02035d8",
"assets/assets/images/image_phone.png": "8b74c4c49edf5d638a975b3dfb008e9c",
"assets/assets/images/img_card_background.png": "0adfafa9db0358fbc6da780050d7dc8a",
"assets/assets/images/intro_step_1.svg": "ad96b8e38b92185f455487eee391f587",
"assets/assets/images/imag_union.png": "ebdeac6cb5c5e658f02a51d475177ee4",
"assets/assets/images/img_forgot_password.svg": "9b63d773fc2221d74a929117dee79845",
"assets/assets/images/persion_paint.svg": "c3b571672c7f5a28e55192fd72e23a1c",
"assets/assets/images/intro_step_3.svg": "3aa807f889b4062a1850bffab91dd5f1",
"assets/assets/images/intro_step_2.svg": "5c7fdecdbcd97c4fdc33f0836d36fa05",
"assets/assets/icons/icon_paypal.png": "a92906241f6d04f239f74b3212e5f899",
"assets/assets/icons/icon_modifiy.svg": "c9b4a1b2bbc92b68fae8556c50e2c454",
"assets/assets/icons/icon_facebook.svg": "73c5bbd7a7c5d850492a6231d700e336",
"assets/assets/icons/icon_ranking.svg": "d61207c943e4de720720500d3272a012",
"assets/assets/icons/icon_avatar.svg": "5b8cc281ee22cc1ba63ea13d2d949ff0",
"assets/assets/icons/icon_trash.svg": "91f94e83840595a29b8d94e99110537b",
"assets/assets/icons/icon_setting.svg": "fc74047823fedf05b183bfdc3756a8f1",
"assets/assets/icons/icon_filter.svg": "bcec162e6da87021e117fa9baf1ac4c6",
"assets/assets/icons/icon_history.svg": "38687098aa73dea79f92ba06bdf72e7a",
"assets/assets/icons/icon_twitter.svg": "5c97e5be25ba08fd8cd28b7b1d99c369",
"assets/assets/icons/icon_book.svg": "7f7af55d62fdbdc07b786ab210dfc19c",
"assets/assets/icons/icon_assigment.svg": "5304dc947f2af7cba2f61ba5ddfb3e41",
"assets/assets/icons/icon_chat.svg": "02e1bce198ed08ce84e3e3ea6941c3c3",
"assets/assets/icons/icon_google.svg": "c9067731c7caf2af7232478314c62daf",
"assets/assets/icons/icon_sun.svg": "99d4472f947189d30cd197249e0ca71c",
"assets/assets/icons/icon_done.svg": "9c66153c0eb428fc1caf390c83f278a9",
"assets/assets/icons/icon_logout.svg": "376b6b67692c4f15b163e7fa38a522cb",
"assets/assets/icons/icon_master.png": "9b955ab51c65138cecd0d5e090632fd3",
"assets/assets/icons/app_icon.png": "b1ed16ae19cc6617fd9e7c464d24fc3d",
"assets/assets/icons/icon_menu.svg": "7906f1e1a5ed39629588d59494948d6e",
"assets/assets/icons/icon_credit.svg": "2e6607d861edec70f04311f653b55811",
"assets/assets/icons/icon_bank.png": "6b71eb38233fc213a26ece1e3ca2a4f3",
"assets/assets/icons/icon_bag.svg": "327e8fb4f455f183aaa0caf22f2614ca",
"assets/assets/icons/icon_home.svg": "cce10f2c6b2838e361b0d1567b44df7e",
"assets/AssetManifest.bin.json": "6aeccb4119050a1955c7eebb4aa7e251",
"assets/fonts/MaterialIcons-Regular.otf": "fe2ac1f6146fd1e375e92fbbb28ceca6",
"assets/AssetManifest.bin": "7010c4d5539ebb92ceefd3b50b476744",
"assets/NOTICES": "b7f51510972c20706649c9ace8335451",
"assets/AssetManifest.json": "adb5c11ad9753e3c3a41969216b18183",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "1beb9842eede801832b05e20f3bcee54",
"icons/Icon-maskable-192.png": "ca50249e8341c1f7ad87c2a5212ece2f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"flutter_bootstrap.js": "919c14587b4d29926ea25fa0d3bf6cc7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"index.html": "5aaf657154f244ced2bfe5c54104afe3",
"/": "5aaf657154f244ced2bfe5c54104afe3",
"main.dart.js": "91010e427f77e6ff244a4122af5f7e15",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "1ebeff3e6dee3cce225f58eeb936ee52",
"version.json": "54d36dbc38c43cba01c9b935618dad17"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
