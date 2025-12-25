//
//  PedigreeKind.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public enum PedigreeKind : String {
  case ADOPTED
  case BIRTH
  case FOSTER
  case SEALING
  case OTHER // TODO: Needs payload
}
