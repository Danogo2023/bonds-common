use aiken/builtin
use aiken/collection/list
use aiken/crypto
use aiken/primitive/bytearray
use cardano/address
use cardano/assets
use cardano/transaction.{Input, NoDatum, Output, OutputReference}
use daken/input_hash
use daken/sort
use daken/types.{Blake2b224Hash, Blake2b256Hash}

pub fn blake2b_256(inputs: List<Input>) -> Blake2b256Hash {
  inputs
    |> list.foldl(
        #"",
        fn(
          Input {
            output_reference: OutputReference { transaction_id, output_index },
            ..
          }: Input,
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
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_256(
  //   list.foldl(
  //     [utxo1, utxo2, utxo3, utxo4, utxo5],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_256([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"8a224d36fc099f567b93a46c52f56e727a0c7f6cab57254ac43266c999713996"
}

pub fn blake2b_256_sort_asc(inputs: List<Input>) -> Blake2b256Hash {
  inputs |> sort.inputs_sort_asc |> blake2b_256
}

test succ_blake2b_256_sort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_256(
  //   list.foldl(
  //     [utxo3, utxo2, utxo1, utxo5, utxo4, utxo4],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_256_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"edb8e46ad76ebbab09a3363156fa4c2e759673576c02b4712e3fbd82c8ed2fa2"
}

pub fn blake2b_256_quicksort_asc(inputs: List<Input>) -> Blake2b256Hash {
  inputs |> sort.inputs_quicksort_asc |> blake2b_256
}

test succ_blake2b_256_quicksort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256_quicksort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_256(
  //   list.foldl(
  //     [utxo3, utxo2, utxo1, utxo5, utxo4, utxo4],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_256_quicksort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"edb8e46ad76ebbab09a3363156fa4c2e759673576c02b4712e3fbd82c8ed2fa2"
}

pub fn blake2b_256_head_sort_asc(inputs: List<Input>) -> Blake2b256Hash {
  when inputs |> sort.inputs_sort_asc |> list.head is {
    Some(i) -> input_hash.blake2b_256(i)
    _ -> #""
  }
}

test succ_blake2b_256_head_sort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_256(
  //   bytearray.concat(
  //     #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
  //     builtin.integer_to_bytearray(False, 0, 0),
  //   ),
  // )
  blake2b_256_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"073c26c6f6bb6461fa1453c4d7eeae9db4571e36faf1cc09a9bd330d059e4070"
}

pub fn blake2b_256_last_sort_asc(inputs: List<Input>) -> Blake2b256Hash {
  when inputs |> sort.inputs_sort_asc |> list.last is {
    Some(i) -> input_hash.blake2b_256(i)
    _ -> #""
  }
}

test succ_blake2b_256_last_sort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 2,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256_last_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_256(
  //   bytearray.concat("lastTxn", builtin.integer_to_bytearray(False, 0, 3)),
  // )
  blake2b_256_last_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"2f3108d8b624b75a80513237e44ba47a2ba6ced3ec281bed292aa3813f51beac"
}

pub fn blake2b_256_salt_head_sort_asc(
  inputs: List<Input>,
  salt: ByteArray,
) -> Blake2b256Hash {
  when inputs |> sort.inputs_sort_asc |> list.head is {
    Some(i) -> input_hash.blake2b_256_salt(i, salt)
    _ -> #""
  }
}

test succ_blake2b_256_salt_head_sort_asc() {
  let salt = #"073c26c6f6bb6461fa1453c4d7eeae9db4571e36faf1cc09a9bd330d059e4070"
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_256_salt_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5], salt) == crypto.blake2b_256(
  //   #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1"
  //     |> bytearray.concat(builtin.integer_to_bytearray(1))
  //     |> bytearray.concat(salt),
  // )
  blake2b_256_salt_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5], salt) == #"ea8d86e9aeff85deeae9b6f82ff5cda21f1186c8749b01c1cc22823dd5d21d9d"
}

pub fn blake2b_224(inputs: List<Input>) -> Blake2b224Hash {
  inputs
    |> list.foldl(
        #"",
        fn(
          Input {
            output_reference: OutputReference { transaction_id, output_index },
            ..
          }: Input,
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
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_224(
  //   list.foldl(
  //     [utxo1, utxo2, utxo3, utxo4, utxo5],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_224([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"8866471e4f94c07f8a2f20f3e825c9ab4899ed1d570a4e4a8e6e7bd7"
}

pub fn blake2b_224_sort_asc(inputs: List<Input>) -> Blake2b224Hash {
  inputs |> sort.inputs_sort_asc |> blake2b_224
}

test succ_blake2b_224_sort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_224(
  //   list.foldl(
  //     [utxo3, utxo2, utxo1, utxo5, utxo4, utxo4],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_224_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"72253eaf3026745c62a86c7da48c5ca22869a57a8f00954f8b0bad1e"
}

pub fn blake2b_224_quicksort_asc(inputs: List<Input>) -> Blake2b224Hash {
  inputs |> sort.inputs_quicksort_asc |> blake2b_224
}

test succ_blake2b_224_quicksort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224_quicksort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_224(
  //   list.foldl(
  //     [utxo3, utxo2, utxo1, utxo5, utxo4, utxo4],
  //     #"",
  //     fn(outref: Input, ret: ByteArray) -> ByteArray {
  //       outref.output_reference.transaction_id
  //         |> bytearray.concat(builtin.integer_to_bytearray(False, 0, outref.output_reference.output_index))
  //         |> bytearray.concat(ret, _)
  //     },
  //   ),
  // )
  blake2b_224_quicksort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"72253eaf3026745c62a86c7da48c5ca22869a57a8f00954f8b0bad1e"
}

pub fn blake2b_224_head_sort_asc(inputs: List<Input>) -> Blake2b224Hash {
  when inputs |> sort.inputs_sort_asc |> list.head is {
    Some(i) -> input_hash.blake2b_224(i)
    _ -> #""
  }
}

test succ_blake2b_224_head_sort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_224(
  //   bytearray.concat(
  //     #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
  //     builtin.integer_to_bytearray(False, 0, 0),
  //   ),
  // )
  blake2b_224_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"c1f18cac6a1c8b9b2188f774bffbd986715ffaf11aa35d6b6108c64f"
}

pub fn blake2b_224_last_sort_asc(inputs: List<Input>) -> Blake2b224Hash {
  when inputs |> sort.inputs_sort_asc |> list.last is {
    Some(i) -> input_hash.blake2b_224(i)
    _ -> #""
  }
}

test succ_blake2b_224_last_sort_asc() {
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: "mid",
        output_index: 2,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224_last_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == crypto.blake2b_224(
  //   bytearray.concat("lastTxn", builtin.integer_to_bytearray(False, 0, 3)),
  // )
  blake2b_224_last_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5]) == #"9bb9389a7f14d13b3557384d56e913d7a7226b963a5d94103b377f59"
}

pub fn blake2b_224_salt_head_sort_asc(
  inputs: List<Input>,
  salt: ByteArray,
) -> Blake2b224Hash {
  when inputs |> sort.inputs_sort_asc |> list.head is {
    Some(i) -> input_hash.blake2b_224_salt(i, salt)
    _ -> #""
  }
}

test succ_blake2b_224_salt_head_sort_asc() {
  let salt = #"073c26c6f6bb6461fa1453c4d7eeae9db4571e36faf1cc09a9bd330d059e4070"
  let utxo1 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo2 =
    Input {
      output_reference: OutputReference {
        transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
        output_index: 0,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo3 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 1,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo4 =
    Input {
      output_reference: OutputReference {
        transaction_id: "lastTxn",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  let utxo5 =
    Input {
      output_reference: OutputReference {
        transaction_id: "beg",
        output_index: 3,
      },
      output: Output {
        address: address.from_script(#""),
        value: assets.zero,
        datum: NoDatum,
        reference_script: None,
      },
    }
  // blake2b_224_salt_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5], salt) == crypto.blake2b_224(
  //   #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1"
  //     |> bytearray.concat(builtin.integer_to_bytearray(False, 0, 1))
  //     |> bytearray.concat(salt),
  // )
  blake2b_224_salt_head_sort_asc([utxo1, utxo2, utxo3, utxo4, utxo5], salt) == #"7cff719ddcbf0f757334fefc6e420628f2a14af2e3c1faeeb4c90a04"
}
