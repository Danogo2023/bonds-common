use aiken/builtin
use aiken/collection/list
use aiken/crypto
use aiken/primitive/bytearray
use cardano/transaction.{OutputReference}
use daken/outref_hash
use daken/sort
use daken/types.{Blake2b224Hash, Blake2b256Hash}

pub fn blake2b_256(out_refs: List<OutputReference>) -> Blake2b256Hash {
  out_refs
    |> list.foldl(
        #"",
        fn(
          OutputReference { transaction_id, output_index }: OutputReference,
          ret: ByteArray,
        ) -> ByteArray {
          builtin.integer_to_bytearray(False, 0, output_index)
            |> bytearray.concat(transaction_id, _)
            |> bytearray.concat(ret, _)
        },
      )
    |> crypto.blake2b_256
}

test succ_blake2b_256() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256([out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5]) == #"8a224d36fc099f567b93a46c52f56e727a0c7f6cab57254ac43266c999713996"
}

test succ_blake2b_256_empty() {
  crypto.blake2b_256(#"") == #"0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8"
}

pub fn blake2b_256_sort_asc(out_refs: List<OutputReference>) -> Blake2b256Hash {
  out_refs |> sort.out_refs_sort_asc |> blake2b_256
}

test succ_blake2b_256_sort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256_sort_asc([out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5]) == #"edb8e46ad76ebbab09a3363156fa4c2e759673576c02b4712e3fbd82c8ed2fa2"
}

pub fn blake2b_256_quicksort_asc(
  out_refs: List<OutputReference>,
) -> Blake2b256Hash {
  out_refs |> sort.out_refs_quicksort_asc |> blake2b_256
}

test succ_blake2b_256_quicksort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256_quicksort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
  ) == #"edb8e46ad76ebbab09a3363156fa4c2e759673576c02b4712e3fbd82c8ed2fa2"
}

pub fn blake2b_256_head_sort_asc(
  out_refs: List<OutputReference>,
) -> Blake2b256Hash {
  when out_refs |> sort.out_refs_sort_asc |> list.head is {
    Some(i) -> outref_hash.blake2b_256(i)
    _ -> #""
  }
}

test succ_blake2b_256_head_sort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 1 }
  let out_ref_2 =
    OutputReference {
      transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
      output_index: 0,
    }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 1 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256_head_sort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
  ) == #"073c26c6f6bb6461fa1453c4d7eeae9db4571e36faf1cc09a9bd330d059e4070"
}

pub fn blake2b_256_last_sort_asc(
  out_refs: List<OutputReference>,
) -> Blake2b256Hash {
  when out_refs |> sort.out_refs_sort_asc |> list.last is {
    Some(i) -> outref_hash.blake2b_256(i)
    _ -> #""
  }
}

test succ_blake2b_256_last_sort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 2 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 1 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256_last_sort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
  ) == #"2f3108d8b624b75a80513237e44ba47a2ba6ced3ec281bed292aa3813f51beac"
}

pub fn blake2b_256_salt_head_sort_asc(
  out_refs: List<OutputReference>,
  salt: ByteArray,
) -> Blake2b256Hash {
  when out_refs |> sort.out_refs_sort_asc |> list.head is {
    Some(i) -> outref_hash.blake2b_256_salt(i, salt)
    _ -> #""
  }
}

test succ_blake2b_256_salt_head_sort_asc() {
  let salt = #"073c26c6f6bb6461fa1453c4d7eeae9db4571e36faf1cc09a9bd330d059e4070"
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 1 }
  let out_ref_2 =
    OutputReference {
      transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
      output_index: 0,
    }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 1 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_256_salt_head_sort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
    salt,
  ) == #"ea8d86e9aeff85deeae9b6f82ff5cda21f1186c8749b01c1cc22823dd5d21d9d"
}

pub fn blake2b_224(out_refs: List<OutputReference>) -> Blake2b224Hash {
  out_refs
    |> list.foldl(
        #"",
        fn(
          OutputReference { transaction_id, output_index }: OutputReference,
          ret: ByteArray,
        ) -> ByteArray {
          builtin.integer_to_bytearray(False, 0, output_index)
            |> bytearray.concat(transaction_id, _)
            |> bytearray.concat(ret, _)
        },
      )
    |> crypto.blake2b_224
}

test succ_blake2b_224() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_224([out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5]) == #"8866471e4f94c07f8a2f20f3e825c9ab4899ed1d570a4e4a8e6e7bd7"
}

test succ_blake2b_224_empty() {
  crypto.blake2b_224(#"") == #"836cc68931c2e4e3e838602eca1902591d216837bafddfe6f0c8cb07"
}

pub fn blake2b_224_sort_asc(out_refs: List<OutputReference>) -> Blake2b224Hash {
  out_refs |> sort.out_refs_sort_asc |> blake2b_224
}

test succ_blake2b_224_sort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_224_sort_asc([out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5]) == #"72253eaf3026745c62a86c7da48c5ca22869a57a8f00954f8b0bad1e"
}

pub fn blake2b_224_quicksort_asc(
  out_refs: List<OutputReference>,
) -> Blake2b224Hash {
  out_refs |> sort.out_refs_quicksort_asc |> blake2b_224
}

test succ_blake2b_224_quicksort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 0 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 0 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_224_quicksort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
  ) == #"72253eaf3026745c62a86c7da48c5ca22869a57a8f00954f8b0bad1e"
}

pub fn blake2b_224_head_sort_asc(
  out_refs: List<OutputReference>,
) -> Blake2b224Hash {
  when out_refs |> sort.out_refs_sort_asc |> list.head is {
    Some(i) -> outref_hash.blake2b_224(i)
    _ -> #""
  }
}

test succ_blake2b_224_head_sort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 1 }
  let out_ref_2 =
    OutputReference {
      transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
      output_index: 0,
    }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 1 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_224_head_sort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
  ) == #"c1f18cac6a1c8b9b2188f774bffbd986715ffaf11aa35d6b6108c64f"
}

pub fn blake2b_224_last_sort_asc(
  out_refs: List<OutputReference>,
) -> Blake2b224Hash {
  when out_refs |> sort.out_refs_sort_asc |> list.last is {
    Some(i) -> outref_hash.blake2b_224(i)
    _ -> #""
  }
}

test succ_blake2b_224_last_sort_asc() {
  let out_ref_1 = OutputReference { transaction_id: "lastTxn", output_index: 0 }
  let out_ref_2 = OutputReference { transaction_id: "mid", output_index: 2 }
  let out_ref_3 = OutputReference { transaction_id: "beg", output_index: 1 }
  let out_ref_4 = OutputReference { transaction_id: "lastTxn", output_index: 3 }
  let out_ref_5 = OutputReference { transaction_id: "beg", output_index: 3 }
  blake2b_224_last_sort_asc(
    [out_ref_1, out_ref_2, out_ref_3, out_ref_4, out_ref_5],
  ) == #"9bb9389a7f14d13b3557384d56e913d7a7226b963a5d94103b377f59"
}

pub fn blake2b_224_salt_head_sort_asc(
  out_refs: List<OutputReference>,
  salt: ByteArray,
) -> Blake2b224Hash {
  when out_refs |> sort.out_refs_sort_asc |> list.head is {
    Some(i) -> outref_hash.blake2b_224_salt(i, salt)
    _ -> #""
  }
}
