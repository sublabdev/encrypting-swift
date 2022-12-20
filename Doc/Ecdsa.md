### ECDSA Example

*NOTE:* `CommonSwift` library can be found [here](https://github.com/sublabdev/common-swift).
The `hex` extension for `String` is defined in `CommonSwift` library.

```Swift
import EncryptingSwift
import CommonSwift

let seed = "0xbb32936d098683d24023663036690bad840cd6b8d6975830f8ef490bc3f1f8e4".hex.decode()
let testValue = UUID().uuidString.data(using: .utf8)

let privateKey = try seed.ecdsa.loadPrivateKey()
let publicKey = try privateKey.ecdsa.publicKey()

let signature = try privateKey.ecdsa.sign(message: testValue)
let isValid = try publicKey.ecdsa.verify(message: testValue, signature: signature)
```
In the above code snippet is shown the process of generating `public`/`private` keys from a `seed`; a `signature`; a how `public` key and `signature` are validated.
For creating a `private` key we use the provided `seed` value. After that, the `private` key is used to generate a `public` one.
Then, the `private` key is used to create a `signature`, using `testValue` as a `message`. After
that, `public` key and `signature` are being checked, using the `testValue` as a `message`

Also, the above process can be done by using `KeyPair` mechanism.

```Swift
import EncryptingSwift
import CommonSwift

let seed = "0xbb32936d098683d24023663036690bad840cd6b8d6975830f8ef490bc3f1f8e4".hex.decode()
let testValue = UUID().uuidString.data(using: .utf8)

let keyPair = try KeyPairFactory.ecdsa.load(seed: seed)
let signature = try keyPair.sign(message: testValue)
let isValid = try keyPair.verify(message: testValue, signature: signature)
```

In the above code `keyPair` is created using `KeyPairFactory` class's load method.
It takes `seed` value as it's only parameter. The created `keyPair` object contains both `private` and `public` keys already generated.
After that, `keyPair`'s `sign(message:)` method is called for getting a `signature`.
As a `message` `testValue` is used.
Finally, `verify(message:signature:)` method is called for `signature` and `public` key verification.