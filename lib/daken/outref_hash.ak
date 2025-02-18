use aiken/builtin
use aiken/crypto
use aiken/primitive/bytearray
use cardano/transaction.{OutputReference}
use daken/types.{Blake2b224Hash, Blake2b256Hash}

pub fn blake2b_256(
  OutputReference { transaction_id, output_index }: OutputReference,
) -> Blake2b256Hash {
  builtin.integer_to_bytearray(False, 0, output_index)
    |> bytearray.concat(transaction_id, _)
    |> crypto.blake2b_256
}

test succ_blake2b_256_1() {
  let out_ref_1 =
    OutputReference {
      transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
      output_index: 0,
    }
  blake2b_256(out_ref_1) == #"073c26c6f6bb6461fa1453c4d7eeae9db4571e36faf1cc09a9bd330d059e4070"
}

test succ_blake2b_256_2() {
  let out_ref_1 =
    OutputReference {
      transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
      output_index: 1,
    }
  blake2b_256(out_ref_1) == #"3a657c80c5fb5a0b103601651b2a71e5c5f0034b24f7a65730ce394e9a6bca2a"
}

pub fn blake2b_256_salt(
  OutputReference { transaction_id, output_index }: OutputReference,
  salt: ByteArray,
) -> Blake2b256Hash {
  builtin.integer_to_bytearray(False, 0, output_index)
    |> bytearray.concat(transaction_id, _)
    |> bytearray.concat(salt)
    |> crypto.blake2b_256
}

test succ_blake2b_256_salt() {
  let salt = #"d53d658b5f7eac3f741389135662a2bf9f2475844141705a5c0514f81e47f9bf"
  let out_ref_1 =
    OutputReference {
      transaction_id: #"23850612667a59e236ceeea412440b446fa697f2b988eb05e070aaa18c8cad0f",
      output_index: 0,
    }
  // blake2b_256_salt(out_ref_1, salt) == crypto.blake2b_256(
  //   #"23850612667a59e236ceeea412440b446fa697f2b988eb05e070aaa18c8cad0f30d53d658b5f7eac3f741389135662a2bf9f2475844141705a5c0514f81e47f9bf",
  // )
  blake2b_256_salt(out_ref_1, salt) == #"fe0fcc207619c84c5d484a93a6fc600c392c50073d47e9c7626da27120115032"
}

pub fn blake2b_224(
  OutputReference { transaction_id, output_index }: OutputReference,
) -> Blake2b224Hash {
  builtin.integer_to_bytearray(False, 0, output_index)
    |> bytearray.concat(transaction_id, _)
    |> crypto.blake2b_224
}

test succ_blake2b_224() {
  let out_ref_1 =
    OutputReference {
      transaction_id: #"2b405c773982c6cddf1d8b8a80769a84851f3ce21febbb227777b3ba43be14f1",
      output_index: 0,
    }
  blake2b_224(out_ref_1) == #"c1f18cac6a1c8b9b2188f774bffbd986715ffaf11aa35d6b6108c64f"
}

pub fn blake2b_224_salt(
  OutputReference { transaction_id, output_index }: OutputReference,
  salt: ByteArray,
) -> Blake2b224Hash {
  builtin.integer_to_bytearray(False, 0, output_index)
    |> bytearray.concat(transaction_id, _)
    |> bytearray.concat(salt)
    |> crypto.blake2b_224
}

test succ_blake2b_224_salt() {
  let salt = #"d53d658b5f7eac3f741389135662a2bf9f2475844141705a5c0514f81e47f9bf"
  let out_ref_1 =
    OutputReference {
      transaction_id: #"23850612667a59e236ceeea412440b446fa697f2b988eb05e070aaa18c8cad0f",
      output_index: 0,
    }
  // blake2b_224_salt(out_ref_1, salt) == crypto.blake2b_224(
  //   #"23850612667a59e236ceeea412440b446fa697f2b988eb05e070aaa18c8cad0f30d53d658b5f7eac3f741389135662a2bf9f2475844141705a5c0514f81e47f9bf",
  // )
  blake2b_224_salt(out_ref_1, salt) == #"65cc4498cbf0ab99f8dcded522bd223091b5652d51169870c379bef9"
}
